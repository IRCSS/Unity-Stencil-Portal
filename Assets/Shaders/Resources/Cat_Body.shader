Shader "Unlit/CatBody"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry-4"}
        LOD 100

                Stencil
    {
        Ref 1
        Comp Equal
    }

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
            };

            struct v2f
            {
                float2 uv     : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4x4 _LookAtToClipPos;
            float4 _Pivot;
            v2f vert (appdata v)
            {
                v2f o;

                float4 pos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.));

                float transition = smoothstep(1.4, 2.5, abs(_Pivot.y * pos.y));

                float4 lookATPos =  mul(_LookAtToClipPos, pos);
                float4 normalPos =  mul(UNITY_MATRIX_VP, pos);

                o.vertex = lerp(lookATPos, normalPos, transition);
                o.uv     = v.uv;
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
