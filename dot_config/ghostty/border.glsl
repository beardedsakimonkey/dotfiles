const int SOLID = 0;               // COLOR_A everywhere
const int GRADIENT_HORIZONTAL = 1; // COLOR_A -> COLOR_B, left to right
const int GRADIENT_VERTICAL = 2;   // COLOR_A -> COLOR_B, bottom to top
const int WAVE = 3;                // COLOR_A <-> COLOR_B, sine wave along the diagonal

const int RED = 0;
const int ORANGE = 1;
const int YELLOW = 2;
const int GREEN = 3;
const int CYAN = 4;
const int BLUE = 5;
const int PURPLE = 6;
const int MAGENTA = 7;
const int PINK = 8;
const int WHITE = 9;

const int GRADIENT_TYPE = WAVE;
const int COLOR_A = PINK;
const int COLOR_B = BLUE;

const float BORDER_RADIUS_PX = 32.0;
const float BORDER_WIDTH_PX = 2.5;
const float BORDER_EDGE_WIDTH_PX = 1.0;
const float GLOW_WIDTH_PX = 38.0;
const float GLOW_FALLOFF_SCALE = 0.15;

const float FOCUS_FADE_DURATION = 0.2;

const float FOCUSED_GLOW_STRENGTH = 0.5;
const float FOCUSED_BORDER_STRENGTH = 0.65;

// Organic noise layers. Each strength can be set to 0.0 to disable the layer.
// Layers sample noise in a border-following frame: x runs along the border,
// y runs inward, so the structure hugs the window edge instead of the screen.

// CURTAINS: aurora-like streaks of glow shooting inward from the border.
const float CURTAIN_SPACING_PX = 26.0; // width of one streak along the border
const float CURTAIN_LENGTH_PX = 110.0; // how slowly a streak evolves inward
const float CURTAIN_STRENGTH = 0.4;

// SWELL: slow large-scale ebb of how far the glow reaches into the window.
const float SWELL_SCALE_PX = 180.0;
const float SWELL_STRENGTH = 0.55;

// WOBBLE: the border line waves like a hand-drawn stroke.
const float WOBBLE_SCALE_PX = 48.0;
const float WOBBLE_PX = 2.0;

// SPARKLE: fine brightness grain on the border line and glow.
const float SPARKLE_SCALE_PX = 8.0;
const float SPARKLE_STRENGTH = 0.35;

// MARBLE: noise swirls the COLOR_A/COLOR_B blend on top of the gradient.
const float MARBLE_SCALE_PX = 64.0;
const float MARBLE_STRENGTH = 0.3;

// Slow crawl of every noise layer; needs custom-shader-animation = true.
const float NOISE_DRIFT_SPEED = 0.3;


// Each palette color has a bright border tone and a deeper glow tone.
vec3 paletteBorderColor(int color)
{
    if (color == RED) return vec3(1.0, 0.3, 0.2);
    if (color == ORANGE) return vec3(1.0, 0.5, 0.1);
    if (color == YELLOW) return vec3(1.0, 0.8, 0.15);
    if (color == GREEN) return vec3(0.2, 1.0, 0.55);
    if (color == CYAN) return vec3(0.1, 0.95, 1.0);
    if (color == BLUE) return vec3(0.15, 0.55, 1.0);
    if (color == PURPLE) return vec3(0.55, 0.3, 1.0);
    if (color == MAGENTA) return vec3(0.85, 0.2, 1.0);
    if (color == PINK) return vec3(1.0, 0.2, 0.45);
    return vec3(0.95, 0.97, 1.0); // WHITE
}

vec3 paletteGlowColor(int color)
{
    if (color == RED) return vec3(1.0, 0.05, 0.0);
    if (color == ORANGE) return vec3(1.0, 0.1, 0.0);
    if (color == YELLOW) return vec3(1.0, 0.45, 0.0);
    if (color == GREEN) return vec3(0.0, 0.7, 0.3);
    if (color == CYAN) return vec3(0.0, 0.35, 1.0);
    if (color == BLUE) return vec3(0.1, 0.2, 1.0);
    if (color == PURPLE) return vec3(0.35, 0.05, 1.0);
    if (color == MAGENTA) return vec3(0.8, 0.05, 1.0);
    if (color == PINK) return vec3(1.0, 0.0, 0.2);
    return vec3(0.55, 0.65, 0.85); // WHITE
}

float randomValue(vec2 cell)
{
    return fract(sin(dot(cell, vec2(127.1, 311.7))) * 43758.5453);
}

float valueNoise(vec2 position)
{
    vec2 cell = floor(position);
    vec2 blend = fract(position);
    blend = blend * blend * (3.0 - 2.0 * blend);

    float top = mix(
        randomValue(cell),
        randomValue(cell + vec2(1.0, 0.0)),
        blend.x
    );
    float bottom = mix(
        randomValue(cell + vec2(0.0, 1.0)),
        randomValue(cell + vec2(1.0, 1.0)),
        blend.x
    );
    return mix(top, bottom, blend.y);
}

float fbm(vec2 position)
{
    float sum = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        sum += amplitude * valueNoise(position);
        position = position * 2.03 + vec2(17.3, 9.1);
        amplitude *= 0.5;
    }
    return sum / 0.9375;
}

// Sample fbm through two offset fbm fields so the result streaks and swirls.
float warpedFbm(vec2 position)
{
    vec2 warp = vec2(
        fbm(position),
        fbm(position + vec2(5.2, 1.3))
    );
    return fbm(position + 1.5 * warp);
}

vec2 noiseDrift()
{
    return iTime * NOISE_DRIFT_SPEED * vec2(1.0, 0.37);
}

float squircleRectangleSdf(vec2 fragCoord)
{
    vec2 halfSize = iResolution.xy * 0.5;
    float radius = min(BORDER_RADIUS_PX, min(halfSize.x, halfSize.y));
    vec2 cornerDistance = abs(fragCoord - halfSize) - (halfSize - vec2(radius));
    vec2 outside = max(cornerDistance, 0.0);
    vec2 outsideSquared = outside * outside;
    float squircleDistance = sqrt(sqrt(dot(outsideSquared, outsideSquared)));

    return squircleDistance
        + min(max(cornerDistance.x, cornerDistance.y), 0.0)
        - radius;
}

// Coordinate that runs along the border, from the SDF gradient's tangent.
float alongBorderCoord(vec2 fragCoord)
{
    float step = 1.0;
    vec2 gradient = vec2(
        squircleRectangleSdf(fragCoord + vec2(step, 0.0))
            - squircleRectangleSdf(fragCoord - vec2(step, 0.0)),
        squircleRectangleSdf(fragCoord + vec2(0.0, step))
            - squircleRectangleSdf(fragCoord - vec2(0.0, step))
    );
    float len = length(gradient);
    vec2 normal = len > 0.0001 ? gradient / len : vec2(0.0, 1.0);
    vec2 tangent = vec2(-normal.y, normal.x);
    return dot(fragCoord, tangent);
}

float gradientBlend(vec2 fragCoord)
{
    vec2 position = fragCoord / iResolution.xy;
    float blend = 0.0; // SOLID
    if (GRADIENT_TYPE == GRADIENT_HORIZONTAL) {
        blend = smoothstep(0.0, 1.0, position.x);
    } else if (GRADIENT_TYPE == GRADIENT_VERTICAL) {
        blend = smoothstep(0.0, 1.0, position.y);
    } else if (GRADIENT_TYPE == WAVE) {
        blend = 0.5 + 0.5 * sin((position.x + position.y) * 6.2831853);
    }

    if (MARBLE_STRENGTH > 0.0) {
        float swirl = warpedFbm(
            fragCoord / MARBLE_SCALE_PX + vec2(53.7, 71.2) + noiseDrift()
        );
        blend = clamp(blend + (swirl - 0.5) * 2.0 * MARBLE_STRENGTH, 0.0, 1.0);
    }
    return blend;
}

vec3 borderColor(float blend)
{
    return mix(paletteBorderColor(COLOR_A), paletteBorderColor(COLOR_B), blend);
}

vec3 glowColor(float blend)
{
    return mix(paletteGlowColor(COLOR_A), paletteGlowColor(COLOR_B), blend);
}

float linearToSrgb(float value)
{
    if (value >= 0.0031308) {
        return 1.055 * pow(value, 1.0 / 2.4) - 0.055;
    }
    return 12.92 * value;
}

float srgbToLinear(float value)
{
    if (value >= 0.04045) {
        return pow((value + 0.055) / 1.055, 2.4);
    }
    return value / 12.92;
}

// OKLab conversions from https://bottosson.github.io/posts/oklab/.
vec3 rgbToOklab(vec3 rgb)
{
    vec3 color = vec3(
        srgbToLinear(rgb.r),
        srgbToLinear(rgb.g),
        srgbToLinear(rgb.b)
    );
    float l = 0.4122214708 * color.r + 0.5363325363 * color.g + 0.0514459929 * color.b;
    float m = 0.2119034982 * color.r + 0.6806995451 * color.g + 0.1073969566 * color.b;
    float s = 0.0883024619 * color.r + 0.2817188376 * color.g + 0.6299787005 * color.b;

    float lRoot = pow(l, 1.0 / 3.0);
    float mRoot = pow(m, 1.0 / 3.0);
    float sRoot = pow(s, 1.0 / 3.0);

    return vec3(
        0.2104542553 * lRoot + 0.7936177850 * mRoot - 0.0040720468 * sRoot,
        1.9779984951 * lRoot - 2.4285922050 * mRoot + 0.4505937099 * sRoot,
        0.0259040371 * lRoot + 0.7827717662 * mRoot - 0.8086757660 * sRoot
    );
}

vec3 oklabToRgb(vec3 oklab)
{
    float lRoot = oklab.r + 0.3963377774 * oklab.g + 0.2158037573 * oklab.b;
    float mRoot = oklab.r - 0.1055613458 * oklab.g - 0.0638541728 * oklab.b;
    float sRoot = oklab.r - 0.0894841775 * oklab.g - 1.2914855480 * oklab.b;

    float l = lRoot * lRoot * lRoot;
    float m = mRoot * mRoot * mRoot;
    float s = sRoot * sRoot * sRoot;

    vec3 linearRgb = vec3(
        +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
    );

    return clamp(
        vec3(
            linearToSrgb(linearRgb.r),
            linearToSrgb(linearRgb.g),
            linearToSrgb(linearRgb.b)
        ),
        0.0,
        1.0
    );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(iChannel0, uv);

    float focusProgress = clamp(
        (iTime - iTimeFocus) / max(FOCUS_FADE_DURATION, 0.0001),
        0.0,
        1.0
    );
    float focus = smoothstep(0.0, 1.0, focusProgress);
    if (iFocus <= 0) {
        focus = 1.0 - focus;
    }
    if (focus <= 0.0) {
        fragColor = color;
        return;
    }

    float squircleRectangle = squircleRectangleSdf(fragCoord);
    float maxGlowExtent = GLOW_WIDTH_PX * (1.0 + SWELL_STRENGTH) + WOBBLE_PX;
    if (squircleRectangle <= -maxGlowExtent || squircleRectangle >= 1.0) {
        fragColor = color;
        return;
    }

    // The mask keeps the outer edge crisp; only borderDistance gets wobbled.
    float squircleMask = 1.0 - smoothstep(0.0, 1.0, squircleRectangle);
    float along = alongBorderCoord(fragCoord);
    vec2 drift = noiseDrift();

    float wobble = 0.0;
    if (WOBBLE_PX > 0.0) {
        wobble = (fbm(vec2(along / WOBBLE_SCALE_PX, 3.7) + drift) - 0.5)
            * 2.0 * WOBBLE_PX;
    }
    float borderDistance = max(-squircleRectangle + wobble, 0.0);

    float reach = 1.0;
    if (SWELL_STRENGTH > 0.0) {
        float swell = fbm(vec2(along / SWELL_SCALE_PX, 9.1) + drift * 0.5);
        reach = mix(1.0 - SWELL_STRENGTH, 1.0 + SWELL_STRENGTH, swell);
    }

    float curtain = 1.0;
    if (CURTAIN_STRENGTH > 0.0) {
        float streak = warpedFbm(
            vec2(along / CURTAIN_SPACING_PX, borderDistance / CURTAIN_LENGTH_PX)
                + vec2(7.7, 2.2)
                + drift
        );
        // Sharpen the midtones so streaks separate instead of blurring.
        streak = smoothstep(0.25, 0.75, streak);
        curtain = mix(1.0 - CURTAIN_STRENGTH, 1.0 + CURTAIN_STRENGTH, streak);
    }

    float sparkle = 1.0;
    if (SPARKLE_STRENGTH > 0.0) {
        vec2 grainPosition = fragCoord / SPARKLE_SCALE_PX + drift * 4.0;
        float broad = valueNoise(grainPosition);
        float fine = valueNoise(grainPosition * 2.07 + vec2(11.7, 4.3));
        float grain = (broad + fine * 0.5) / 1.5;
        sparkle = mix(1.0 - SPARKLE_STRENGTH, 1.0 + SPARKLE_STRENGTH, grain);
    }

    float blend = gradientBlend(fragCoord);

    float scaledGlowDistance = borderDistance * GLOW_FALLOFF_SCALE / reach;
    float glowDenominator = max(
        scaledGlowDistance * scaledGlowDistance,
        0.0001
    );
    vec3 glow = 1.0 - exp(-glowColor(blend) / glowDenominator);
    glow *= 1.0 - smoothstep(0.0, GLOW_WIDTH_PX * reach, borderDistance);
    glow *= squircleMask;

    float border = 1.0 - smoothstep(
        BORDER_WIDTH_PX - BORDER_EDGE_WIDTH_PX,
        BORDER_WIDTH_PX,
        borderDistance
    );
    border *= squircleMask;

    vec3 glowAmount = glow * FOCUSED_GLOW_STRENGTH * focus * sparkle * curtain;
    // The border picks up half the curtain variation so bright streaks appear
    // to emanate from bright stretches of the line.
    float borderAmount = clamp(
        border * FOCUSED_BORDER_STRENGTH * focus * sparkle
            * mix(1.0, curtain, 0.5),
        0.0,
        1.0
    );
    color.rgb = clamp(color.rgb + glowAmount, 0.0, 1.0);
    vec3 oklabColor = rgbToOklab(color.rgb);
    oklabColor = mix(oklabColor, rgbToOklab(borderColor(blend)), borderAmount);
    color.rgb = oklabToRgb(oklabColor);

    fragColor = color;
}
