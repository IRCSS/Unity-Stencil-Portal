Shader "Unlit/Flames"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
             Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        LOD 100
        Blend One One

        Cull Off

        Stencil
    {
        Ref 0
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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

                float3 withOffset = v.vertex;
                float heightMultiplier = smoothstep(0.55, 0.65, v.uv.y);

                withOffset.x += sin(withOffset.y *2000. + _Time.y*5.) * 0.001 *heightMultiplier;
                withOffset.y += sin(withOffset.z *200. + _Time.y*5. + 0.2) * 0.001 *heightMultiplier + sin(withOffset.z *400. + _Time.y*10. + 0.5) * 0.0005 *heightMultiplier;
                withOffset.z += sin(withOffset.x *200. + _Time.y*5. + 0.1) * 0.001 *heightMultiplier + sin(withOffset.x *400. + _Time.y*10. + 0.4) * 0.0005 *heightMultiplier;

                o.vertex = UnityObjectToClipPos(withOffset);
                o.uv     = TRANSFORM_TEX(v.uv, _MainTex);
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
