Shader "Custom/PixelPerfectGrid"
{
    // composed by chatgpt after metric ton of work
    Properties
    {
        _GridColor ("Grid Color", Color) = (1, 1, 1, 1)
        _LineWidth ("Line Width (Pixels)", Float) = 1.0
        _GridScale ("Grid Scale", Float) = 1.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Cull Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            float _GridScale;
            float _LineWidth;
            float4 _GridColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.screenPos = ComputeScreenPos(o.pos);  // Get screen coordinates
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // Shift grid so lines run through world origin (0,0)
                float2 gridUV = (i.worldPos.xz + _GridScale * 0.5) / _GridScale;
                float2 gridUVFrac = abs(frac(gridUV) - 0.5);

                // Get screen-space pixel size (prevents distortion at angles)
                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                float pixelSize = length(float2(ddx(screenUV.x), ddy(screenUV.y)));

                // Compute line thickness in screen space
                float fixedThickness = _LineWidth * pixelSize;

                // Anti-aliasing fix: Use fwidth to ensure smooth transitions
                float2 lineAA = fwidth(gridUV);
                float2 smoothThickness = max(lineAA, fixedThickness);

                // Smoothstep for proper blending and anti-aliasing
                float2 gridLines = smoothstep(0.0, smoothThickness, gridUVFrac);
                float lineMask = min(gridLines.x, gridLines.y);

                return float4(_GridColor.rgb, 1.0 - lineMask); // Alpha-based transparency
            }
            ENDCG
        }
    }
}