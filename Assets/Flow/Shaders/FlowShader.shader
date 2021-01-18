Shader "Effects/FlowShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FlowMap("FlowMap(RG)", 2D) = "black"{}
        _Color("Color", color) = (1,1,1,1)
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
            #include "Flow.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_FlowMap;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 flowVector = tex2D(_FlowMap, i.uv).rg * 2 - 1;
                float3 uvw = FlowUVW(i.uv, flowVector, _Time.y);
                float4 col = tex2D(_MainTex, uvw.xy) * uvw.z * _Color;
                
                
                float3 flowCol = float3(flowVector, 0);

                return col;
            }
            ENDCG
        }
    }
}
