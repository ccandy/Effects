Shader "Effects/FlatFlatWire"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            


            struct appdata
            {
                float4 vertex : POSITION;
                //float3 worldPos:TEXCOORD1;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal:TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            float CalcuateDiffuse(float3 normalDir, float3 lightDir)
            {
                return dot(normalDir, lightDir);
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                //float diffuse = CalcuateDiffuse
                return col;
            }
            ENDCG
        }
    }
}
