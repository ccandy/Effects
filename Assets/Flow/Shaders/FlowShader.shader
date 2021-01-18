Shader "Effects/FlowShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FlowMap("FlowMap(RG)", 2D) = "black"{}
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
                // sample the texture

                float2 uv = FlowUV(i.uv, _Time.y);

                float4 col = tex2D(_MainTex, uv);
                
                return col;
            }
            ENDCG
        }
    }
}
