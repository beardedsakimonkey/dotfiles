const float CURSOR_ANIMATION_DURATION = 0.12;
// Set to 1.0 to only animate the cursor when its width/height changes.
const float CURSOR_ANIMATE_MODE_CHANGES_ONLY = 0.0;

const float CURSOR_EDGE_SOFTNESS_PX = 1.0;
const float CURSOR_WIDTH_CHANGE_THRESHOLD = 0.5;
const float CURSOR_HEIGHT_CHANGE_THRESHOLD = 0.5;

float easeOutCubic(float t)
{
    float inv = 1.0 - clamp(t, 0.0, 1.0);
    return 1.0 - inv * inv * inv;
}

vec2 normalizeCoord(vec2 value, float isPosition)
{
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float rectSdf(vec2 point, vec2 center, vec2 halfSize)
{
    vec2 dist = abs(point - center) - halfSize;
    return length(max(dist, 0.0)) + min(max(dist.x, dist.y), 0.0);
}

float rectMask(vec2 point, vec4 cursor)
{
    vec4 normalizedCursor = vec4(normalizeCoord(cursor.xy, 1.0),
                                 normalizeCoord(cursor.zw, 0.0));
    vec2 offsetFactor = vec2(-0.5, 0.5);
    vec2 center = normalizedCursor.xy - (normalizedCursor.zw * offsetFactor);
    vec2 halfSize = normalizedCursor.zw * 0.5;
    float sdf = rectSdf(normalizeCoord(point, 1.0), center, halfSize);
    float softness = normalizeCoord(vec2(CURSOR_EDGE_SOFTNESS_PX), 0.0).x;
    return 1.0 - smoothstep(0.0, softness, sdf);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    vec4 originalColor = color;

    vec2 cursorSize = max(iCurrentCursor.zw, iPreviousCursor.zw);
    vec2 sizeChange = abs(iCurrentCursor.zw - iPreviousCursor.zw);
    float widthChanged = step(cursorSize.x * CURSOR_WIDTH_CHANGE_THRESHOLD, sizeChange.x);
    float heightChanged = step(cursorSize.y * CURSOR_HEIGHT_CHANGE_THRESHOLD, sizeChange.y);
    float isModeChange = max(widthChanged, heightChanged);
    float shouldAnimate = mix(1.0, isModeChange, CURSOR_ANIMATE_MODE_CHANGES_ONLY);

    // Calculate the animated cursor position.
    float elapsed = iTime - iTimeCursorChange;
    float progress = easeOutCubic(elapsed / CURSOR_ANIMATION_DURATION);
    vec4 cursor = mix(iPreviousCursor, iCurrentCursor, progress);
    cursor = mix(iCurrentCursor, cursor, shouldAnimate);

    // Draw the animated cursor.
    float cursorMask = rectMask(fragCoord.xy, cursor) * iCursorVisible.x;
    color.rgb = mix(color.rgb, iCurrentCursorColor.rgb, cursorMask * iCurrentCursorColor.a);

    // Redraw the original color inside the current cursor bounds.
    float currentCursorMask = rectMask(fragCoord.xy, iCurrentCursor) * iCursorVisible.x;
    color.rgb = mix(color.rgb, originalColor.rgb, currentCursorMask);

    fragColor = vec4(color);
}
