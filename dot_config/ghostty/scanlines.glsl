const float SCANLINE_STRENGTH = 0.05;

// Scanline frequency independent of the window size.
const float SCANLINE_PERIOD_PX = 20.0;

// Direction vector: (1,0) → horizontal, (0,1) → vertical, (1,1) → diagonal
const vec2  SCANLINE_DIRECTION = vec2(1, 1);


float textMask(vec3 color)
{
    vec3 diff = abs(color - iBackgroundColor);
    float channelDelta = max(max(diff.r, diff.g), diff.b);
    return smoothstep(0.08, 0.18, channelDelta);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    float text = textMask(color.rgb);

    // Project each pixel onto the configured scanline axis, then generate a
    // repeating brightness waveform across that 1D position.
    float scanPosition = dot(fragCoord.xy, normalize(SCANLINE_DIRECTION));
    float scanline = 0.5 + 0.5 * sin((scanPosition / SCANLINE_PERIOD_PX) * 6.28318530718);

    float scanlineStrength = SCANLINE_STRENGTH * (1.0 - text);
    float scanlineMultiplier = (1.0 - scanlineStrength) + (scanline * scanlineStrength);
    color.rgb *= scanlineMultiplier;

    fragColor = vec4(color);
}
