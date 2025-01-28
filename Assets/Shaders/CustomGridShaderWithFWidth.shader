Shader "Custom/GridShaderWithFwidth"
{
    // adviced by ChatGPT
    Properties
    {
        _GridColor ("Grid Color", Color) = (1, 1, 1, 1)
        _LineWidth ("Line Width (Screen Space)", Float) = 1.0
        _GridScale ("Grid Scale", Float) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Cull Off
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
                // Calculate UV coordinates for the grid in world space
                float2 gridUV = i.worldPos.xz / _GridScale;

                // Calculate the fractional part of the UV (distance to grid lines)
                float2 gridUVFrac = abs(frac(gridUV) - 0.5);

                // Use screen-space derivatives to ensure consistent line thickness
                float2 lineThickness = fwidth(gridUV) * _LineWidth;

                // Check if we are within the line boundaries
                float2 lineMask = smoothstep(0.0, lineThickness, lineThickness - gridUVFrac);

                // Combine the masks for both X and Z axes
                float lineIntensity = max(lineMask.x, lineMask.y);

                // Return grid color with transparency
                return float4(_GridColor.rgb, lineIntensity);
            }
            ENDCG
        }
    }
}