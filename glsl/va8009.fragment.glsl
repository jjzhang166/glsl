#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float half_pi = 1.5707963;

void main( void ) {
	float radius = 0.75;
	vec2 center = vec2(cos(time)*0.5 + 0.5, sin(time)*0.5 + 0.5);
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float dist = distance(position, center);	
	vec2 rv = position - center;
	float x = clamp(dist / radius, 0.0, 1.0);
    	float k = 1.0 - 0.6 * (1.0 - sin(x * half_pi));
    	position = center + rv * k;  
	
	
	float color = 0.0;
	for(int i=0; i<20;++i){
		color -= sin(position.x*resolution.x*0.1)*cos(position.y*resolution.y*0.1) + tan(position.y*1.25);
		color += (time);	
		
	}
	
	
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 ).bbba;

}