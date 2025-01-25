Shader "Custom/CustomGridShader"
{
    Properties
    {
        _GridColor ("Grid Color", Color) = (1, 1, 1, 1)
        _BackgroundColor ("Background Color", Color) = (0, 0, 0, 1)
        _LineWidth ("Line Width", Float) = 1.0
        _GridScale ("Grid Scale", Float) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            float _GridScale;
            float _LineWidth;
            float4 _GridColor;
            float4 _BackgroundColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = v.vertex.xyz;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // Compute grid lines in world space
                float2 gridUV = abs(frac(i.worldPos.xz / _GridScale) - 0.5);
                float lineIntensity = step(gridUV.x, _LineWidth / _GridScale) + step(gridUV.y, _LineWidth / _GridScale);
                lineIntensity = saturate(lineIntensity);

                // Mix colors based on line presence
                return lerp(_BackgroundColor, _GridColor, lineIntensity);
            }
            ENDCG
        }
    }
}