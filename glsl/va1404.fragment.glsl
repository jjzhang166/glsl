#ifdef GL_ES
precision mediump float;
#endif

#define RADIANS 0.017453292

// this is your brain on fractals
// @acaudwell

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct IFS {
    vec3  pos;
    mat4  matrix;
    float scale;
};

// http://www.fractalforums.com/3d-fractal-generation/kaleidoscopic-(escape-time-ifs)
	
IFS fractal(vec3 pos, vec3 dims, float scale, vec3 axis, float angle) {

    angle *= RADIANS;
	
    float c = cos(angle);
    float s = sin(angle);
	
    vec3 t = (1.0-c) * axis;
	
    //rotate + scale
    mat4 m = mat4(
	    vec4((c + t.x * axis.x),          t.y * axis.x - s * axis.z, t.z * axis.x + s * axis.y, 0.0) * scale,
	    vec4(t.x * axis.y + s * axis.z, (c + t.y * axis.y),          t.z * axis.y - s * axis.x, 0.0) * scale,
	    vec4(t.x * axis.z - s * axis.y, t.y * axis.z + s * axis.x, (c + t.z * axis.z),          0.0) * scale,
            vec4(0.0, 0.0, 0.0, 1.0)
    ); 

    //translate
    m *= mat4(1.0, 0.0, 0.0, 0.0,
              0.0, 1.0, 0.0, 0.0,
              0.0, 0.0, 1.0, 0.0, 
              dims.x, dims.y, dims.z, 1.0);

    IFS ifs;
	
    ifs.pos    = pos;
    ifs.matrix = m;
    ifs.scale  = pow( scale, -15.0 );
	
    return ifs;	
}

float dist(in vec3 p, in IFS ifs) {
		
    vec4 q = vec4(p+ifs.pos, 1.0);	
	
    for(int i=0;i<15;i++) {
       q = ifs.matrix * abs(q); 
    }
 	
    return length(q) * ifs.scale;    
}

void main( void ) {

    vec2 uv = (gl_FragCoord.xy / resolution) * 2.0 - 1.0;

    vec3 origin = vec3(0.0, 0.0, -2.6);

    float fov    = tan(65.0 * 0.5 * RADIANS);
    float aspect = resolution.x/resolution.y; 
	
    vec3 ray = origin;
    vec3 dir = normalize( vec3( uv.x * aspect * fov, uv.y * fov, 1.0 ) );
	
    float t = time* 0.5;	
	
    IFS ifs = fractal(vec3(0.0), vec3(-.55, -.2, -0.2), 1.5, normalize(vec3(sin(t*0.25), cos(t*0.25), 1.0)), sin(t*0.15) * 360.0 );

    float d;
    for(int i=0;i<13;i++) {
         d = dist(ray, ifs);
	 ray += dir * d;
    }
		
    float ao =  dist(ray - dir * 0.3, ifs) + dist(ray - dir * 0.5, ifs) ;
	
    vec3 c = vec3(0.95, 0.8, 0.7);	
	
    gl_FragColor = vec4(mix(c, vec3(1.0, 1.0, 1.0), d) * ao + d * length(ray) * vec3(1.0, 1.0, 0.75), 1.0);
}