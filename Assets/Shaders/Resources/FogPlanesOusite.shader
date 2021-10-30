Shader "Unlit/FogPlanesOutside"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FBM("FBM", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
       //  Blend One One
        Cull Off
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                float4 color  : COLOR;
            };

            struct v2f
            {
                float2 uv     : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color  : TEXCOORD1;
                float4 pos    : TEXCOOR2;
            };

#include "SimplexNoise3D.hlsl"

            sampler2D _MainTex;
            sampler2D _FBM;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv     = TRANSFORM_TEX(v.uv, _MainTex);
                o.pos    = v.vertex;
                o.color  = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                
           


                float alpha = 1.;

                float simplex = 0.;
                float basePeriod = 10.;
                float baseAmplitude = 3.7;
                float bigMask = smoothstep(-0.2, 0.4, (SimplexNoise((i.pos + float3(_Time.y*0.025, 0., _Time.y*0.02)) * 6.)));

                for(float f = 0.; f< 5.; f++)
                {
                    simplex += abs((SimplexNoise((i.pos + float3(_Time.y*0.025, 0., _Time.y*0.02)) * basePeriod) / 107.)) *baseAmplitude;
                    basePeriod *=2.0;
                    baseAmplitude /= 2.0;
                }


             
                float2 borders = smoothstep(float2(0.5, 0.5), float2(0.1, 0.4), abs(i.uv - 0.5));

                alpha = simplex * bigMask * 1.5;
                float3 c = float3(0.1, 0.1, 0.1)*0.5 + col;
                return float4(c.xyz /*col.xyz *1.*/ /**  alpha * borders.x * borders.y*/, alpha * borders.x * borders.y) ;
            }
            ENDCG
        }
    }
}
