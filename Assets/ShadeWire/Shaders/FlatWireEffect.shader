﻿Shader "Effects/FlatWireEffect"
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
                float2 uv : TEXCOORD0;
                float3 worldPos :TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos :TEXCOORD1;
            };

            float Diffuse(float3 lightDir, float3 normalDir) 
            {
                return saturate(dot(lightDir, normalDir));
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                    
                float3 dxdp = ddx(i.worldPos);
                float3 dydp = ddy(i.worldPos);
                
                float3 normal = normalize(cross(dxdp, dydp));
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diffuse = Diffuse(lightDir, normal);
                float4 finalCol = diffuse * col;


                return finalCol;
            }
            ENDCG
        }
    }
}
