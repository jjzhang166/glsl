#ifdef GL_ES
precision highp float;
#endif

// by @acaudwell
// modifications by @alteredq

// based on fractal discovered by knighty:
// http://www.fractalforums.com/3d-fractal-generation/kaleidoscopic-(escape-time-ifs)/

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
uniform sampler2D backbuffer;

#define MAX_RAY_STEPS 12
#define MAX_DE_STEPS  25
#define M mat4(-5.740254e-01, 4.547220e-01, 1.309093e+00, 0.000000e+00, -4.547220e-01, 1.276698e+00, -6.428610e-01, 0.000000e+00, -1.309093e+00, -6.428610e-01, -3.507233e-01, -0.000000e+00, 3.896400e-01, -1.814265e-01, -5.258469e-02, 1.00000e+0-(mouse.x)*0.50)

float aspect_ratio = resolution.y / resolution.x;
float ray_scale    = (1.0 / max(resolution.x, resolution.y)) * 0.67;
float fov          = tan ( 45.0 * 0.017453292 * 0.5 );

float distance(vec3 p) {

    vec4 q = vec4(p, 1.0);

    for(int i=0;i<MAX_DE_STEPS;i++) {
        q = M * abs(q);
    }

    return length(q) * pow(1.5, float(-MAX_DE_STEPS));
}

void main( void ) {

    vec2 pp = gl_FragCoord.xy / resolution;
    vec2 tx = 0.5*pp-0.5;

    float a  = 0.0125 * time;
    float sa = sin(a);
    float ca = cos(a);

    vec3 dir = vec3( tx.x * fov , tx.y * fov * aspect_ratio, 4.0 );
 
    dir.xy   = vec2( dir.x * ca - dir.y * sa, dir.x * sa + dir.y * ca);
    dir.xz   = vec2( dir.x * ca - dir.z * sa, dir.x * sa + dir.z * ca);

    dir = normalize(dir);

    vec3 cam = vec3(0.0, 0.0, -6.0);
    cam.xz   = vec2( cam.x * ca - cam.z * sa, cam.x * sa + cam.z * ca);

    vec3 ray = cam;

    float l  = 0.0;
    float d  = 0.0;
    float e  = 0.00001;
    float it = 0.80;

    for(int i=0;i<MAX_RAY_STEPS;i++) {
        d = distance(ray);

        ray += d * dir;
        l += d;

        if(d<1.0*e) break;

        e  = ray_scale * l*0.24;
        it++;
    }

    float f = 1.0-(it/float(MAX_RAY_STEPS));

    float s = max(0.0, pow(1.0-d,50.0));

    vec3 bg = vec3(4.0*pow(length(tx),18.5), 0.0, 0.0 );

    gl_FragColor = vec4(bg + vec3(pp.x, 0.0, pp.y)*f*s, 1.0);

	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	float aspect = resolution.x/resolution.y;
	float dx = abs( position.y -0.5 )* 4.0 / resolution.x;
	float dy = dx * aspect;
	
	vec4 v0 = texture2D( backbuffer, position );
	vec4 v1 = texture2D( backbuffer, mod ( position + vec2( 0.0, dy ), 1.0 ) );
	vec4 v2 = texture2D( backbuffer, mod ( position + vec2( dx, 0.0 ), 1.0 ) );
	vec4 v3 = texture2D( backbuffer, mod ( position + vec2( 0.0, -dy ), 1.0 ) );
	vec4 v4 = texture2D( backbuffer, mod ( position + vec2( -dx, 0.0 ), 1.0 ) );
	vec4 v5 = texture2D( backbuffer, mod ( position + vec2( dx, dy ), 1.0 ) );
	vec4 v6 = texture2D( backbuffer, mod ( position + vec2( -dx, -dy ), 1.0 ) );
	vec4 v7 = texture2D( backbuffer, mod ( position + vec2( dx, -dy ), 1.0 ) );
	vec4 v8 = texture2D( backbuffer, mod ( position + vec2( -dx, dy ), 1.0 ) );
	
	vec4 ss = v0 + v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8;
	gl_FragColor = mix( gl_FragColor * gl_FragColor, 0.15 * ss, 0.65 ) ;
}