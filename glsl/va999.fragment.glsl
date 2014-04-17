#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float PI = 3.141592;

float pulse(float a, float b, float fuzz, float x) {
    float result = smoothstep(a, a + fuzz, x) - smoothstep(b - fuzz, b, x);
return result;
}

float circle(vec2 position, vec2 center, float radius, float strokeWidth, float fuzz) {
    float d = distance(center, position);
    return pulse(radius - strokeWidth * 0.5, radius + strokeWidth * 0.5, fuzz, d);
}

mat3 rotate(float angle) {
    return mat3(
        vec3(cos(angle), -sin(angle), 0.0),
	vec3(sin(angle), cos(angle), 0.0),
	vec3(0.0, 0.0, 1.0)
    );
}

mat3 translate(vec2 t) {
    return mat3(
        vec3(1.0, 0.0, 0.0),
	vec3(0.0, 1.0, 0.0),
	vec3(-t.x, -t.y, 1.0)
    );
}

float segment(vec2 position, float width, float height, float fuzz) {
    float x = pulse(-width * 0.5, width * 0.5, fuzz, position.x);
    float y = pulse(-height * 0.5, height * 0.5, fuzz, position.y);
    return x * y;
}

float xmark(vec2 position, vec2 translation, float size, float strokeWidth) {
    vec3 pos1 = rotate(PI * 0.25) * translate(translation) * vec3(position, 1.0);
    vec3 pos2 = rotate(-PI * 0.25) * translate(translation) * vec3(position, 1.0);
    float v = 0.0;
    v += segment(pos1.xy, size, strokeWidth, 0.001);
    v += segment(pos2.xy, size, strokeWidth, 0.001);
    return v;
}

float ngon4_xmark(vec2 position, vec2 center, float radius, float dir) {
    float c = 0.0;
    float theta = PI * 2.0 / 4.0;
    for(int i = 0; i < 4; i++) {
        float x = center.x + radius * cos(theta * float(i) + time * dir);
	float y = center.y + radius * sin(theta * float(i) + time * dir);
	c += xmark(position, vec2(x, y), 0.1, 0.01);
    }
    return c;
}

void main( void ) {
    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    float aspect_ratio = resolution.x / resolution.y;
    float offx = (resolution.x - resolution.y) / resolution.x * 0.5;
    position.x -= offx;
    position.x = position.x * aspect_ratio;
    position.y = 1.0 - position.y;
	
    float vs = sin(100.0 * PI * 2.0 * position.x * time * 0.1);
    float vt = sin(100.0 * PI * 2.0 * position.y * time * 0.1);    
    float check = vs * vt > 0.0 ? 1.0 : 0.0;
    	
    float color = 0.0;
    float cx = 0.5;
    float cy1 = 0.275; 
    float cy2 = 0.725;
    float circle1 = circle(position, vec2(cx, cy1), 0.225, 0.05, 0.005);
    float circle2 = circle(position, vec2(cx, cy2), 0.225, 0.05, 0.005);
    color += circle1 * ((1.0 + sin(PI * 0.5 * time)) * 0.5 * 0.5 + 0.5) * check;
    color += circle2 * ((1.0 + cos(PI * 0.5 * time)) * 0.5 * 0.5 + 0.5) * check;
    color += ngon4_xmark(position, vec2(cx, cy1), 0.225, 1.0) * 0.5;
    color += ngon4_xmark(position, vec2(cx, cy2), 0.225, -1.0) * 0.5;
    
    color = 1.0 - color;
    gl_FragColor = vec4( vec3( color, color, color), 1.0 );
}