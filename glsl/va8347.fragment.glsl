#ifdef GL_ES
precision mediump float;
#endif

#define PI 4.14

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 fromYCbCr(vec3 yCbCr) {
    mat3 m = mat3(
        1.000,  1.000,  1.000,
        0.000, -0.343,  1.765,
        1.400, -0.711,  0.000
    );
    vec3 tmp = yCbCr * vec3(255.0, 128.0, 128.0);
    vec3 t = m * tmp;
    vec3 rgb = t / vec3(255.0, 255.0, 255.0);
    rgb = clamp(rgb, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    return rgb;
}

float bias(float b, float x) {
    return pow(x, log(b) / log(0.5));
}

float gain(float g, float x) {
    if (x < 0.5) {
        return bias(1.0 - g, 2.0 * x) / 2.0;
    }
    else {
        return 1.0 - bias(1.0 - g, 2.0 - 2.0 * x) / 2.0;
    }
}

float hash(float n) {
	return fract(sin(n)*43758.5453);
}

float noise(in vec2 x) {
	vec2 p = floor(x);
	vec2 f = fract(x);

    f = f * f * (3.0 - 2.0 * f);
    float n = p.x + p.y * 57.0;
    float res = mix(mix(hash(n + 0.0), hash(n + 1.0), f.x), mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y);
    return res;
}

float red = radians(140.0);
float blue = red + radians(180.0);
float saturation = 1.0;

float cbRed = cos(red) * saturation;
float crRed = sin(red) * saturation;
float cbBlue = cos(blue) * saturation;
float crBlue = sin(blue) * saturation;

float flareFactor(float x) {
    return pow(clamp(1.0 - abs(x * 8.0), 0.0, 1.0), 30.0);
}
	
void main( void ) {
    vec2 position = gl_FragCoord.xy / resolution.xy;
	
    // parameters
    float brightness = mouse.x;
    float size = mouse.y;
    float hue = sin(time * 0.1 * PI) * 0.5 + 0.5;
    
    // Distance
    vec2 pos = (position * vec2(2, 2) - vec2(1, 1)) * vec2(resolution.x / resolution.y, 1.0) / size;
    float d = clamp(1.0 - length(pos), 0.0, 1.0);
    
    // Angle
    float a = atan(pos[1], pos[0]) / PI + 0.5;
    
    float glow = pow(d, 10.0) * 1.0;
    float corona = pow(d, 4.0) * 0.5;
    float rays = noise(vec2(a * 6.0 * PI, 0.0)) * pow(d / 1.2, 6.0);
    float center = (flareFactor(pos[0]) + flareFactor(pos[1])) * d * pow(brightness, 8.0);
	
    float cb = mix(cbRed, cbBlue, hue);
    float cr = mix(crRed, crBlue, hue);
    float y = (rays + glow + corona + center) * brightness;
    vec3 color = fromYCbCr(vec3(y, cb * y, cr * y));
	    
    gl_FragColor = vec4(color, 1.0);
}