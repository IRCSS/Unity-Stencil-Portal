Shader "Unlit/GhostMaterial"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color   ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
                Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        LOD 100

                    Blend One One
            


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
#include "SimplexNoise3D.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color  : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 vColor : TEXCOORD00;
            };


            float3 simplex3D(float3 coord)
            {
                return float3(SimplexNoise(coord), SimplexNoise(coord + float3(214.6, 2.215, 721.2)), SimplexNoise(coord +float3(-62.85, 42.631, 821.2) ));
            }

            float rand (float seed)
            {
                return frac(sin(seed * 67.215) *82.165);
            }

            float rand3D(float seed)
            {
                return float3(rand(seed + 6.21), rand(seed), rand(seed + 78.214));
            }

            float _timer;
            float _RandomSeed;
            float _RunIndex;

            sampler2D _MainTex;
            float4 _Color;
            v2f vert (appdata v)
            {
                v2f o;

                float fracTime = _timer;
                float indexTime = _RunIndex;

                float3 basePosition = v.vertex;
                       basePosition += float3(0.0, 0.0, fracTime*0.3);

                basePosition += simplex3D(basePosition*6. + rand3D(indexTime + _RandomSeed) * 10.0)*0.04 + simplex3D(basePosition*25. + rand3D(indexTime+13 + _RandomSeed) * 25.0) *0.003;

                o.vertex = UnityObjectToClipPos(basePosition);
               
                o.vColor =  v.color * smoothstep(0.4, 0.1, abs(0.5- fracTime));
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = _Color * i.vColor;
                return col;
            }
            ENDCG
        }
    }
}
