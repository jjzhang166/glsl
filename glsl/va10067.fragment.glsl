#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define PI acos(1.0)

// http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	

	float l = length(gl_FragCoord.xy - mouse.xy * resolution.xy);
	vec2 waves = normalize(vec2(cos(1.0) / 2.0, sin(1.0) / 4.0)) * -5.0;
	vec2 pos = (gl_FragCoord.xy + waves) / resolution.xy;         
	vec3 col = texture2D(backbuffer, mod(pos, 1.0)).rgb;
	
	
	float dist = distance(gl_FragCoord.xy, mouse.xy * resolution.xy);
	//float dist = 20.0;
	if (mod(dist + 5.0, 10.0) < 5.0 && dist<65.0)
	{
		float random = rand( vec2(0.0,1.0) ) * time;
		col = vec3(rand( vec2(0.0,1.0) ) * time, random, rand( vec2(0.0,1.0) ) * time);
	}
	gl_FragColor = vec4(col, 1.0);

}