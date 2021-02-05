Shader "Effects/FlatWireGeoEffect"
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
            #pragma geometry MyGeometryProgram


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };
            
            struct v2g
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos:TEXCOORD1;
                float3 normal:TEXCOORD2;
            };

            float Diffuse(float3 lightDir, float3 normalDir)
            {
                return saturate(dot(lightDir, normalDir));
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2g vert (appdata v)
            {
                v2g o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.normal = v.normal;
                return o;
            }

            float4 frag (v2g i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diffuse = Diffuse(lightDir, i.normal);
                float4 finalCol = diffuse * col;
                
                return finalCol;
            }

           [maxvertexcount(3)]
           void MyGeometryProgram(triangle v2g i[3], inout TriangleStream<v2g> stream)
            {
               float3 p0 = i[0].worldPos.xyz;
               float3 p1 = i[1].worldPos.xyz;
               float3 p2 = i[2].worldPos.xyz;

               float3 v1 = p1 - p0;
               float3 v2 = p2 - p0;

               float3 worldNormal = normalize(cross(v1, v2));
               i[0].normal = worldNormal;
               i[1].normal = worldNormal;
               i[2].normal = worldNormal;

               stream.Append(i[0]);
               stream.Append(i[1]);
               stream.Append(i[2]);
            }
            ENDCG
        }
    }
}
