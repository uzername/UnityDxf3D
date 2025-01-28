Shader "Custom/GridShaderWithTransparency"
{
    // adviced by ChatGPT
    Properties
    {
        _GridColor ("Grid Color", Color) = (1, 1, 1, 1)
        _LineWidth ("Line Width", Float) = 1.0
        _GridScale ("Grid Scale", Float) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

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

                // Output the grid color with transparency
                return float4(_GridColor.rgb, lineIntensity); // Alpha matches the grid line intensity
            }
            ENDCG
        }
    }
}