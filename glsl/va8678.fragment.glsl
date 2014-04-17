#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec3 v;
float pi = 3.1415926535;
vec3 rn;

float rand(vec3 r) { return fract(sin(dot(r.xy,vec2(1.38984*sin(r.z),1.13233*cos(r.z))))*653758.5453); }

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0, 0.0, 0.0);

	float dist;
	
	float x;
	float angle;
	float maxdiv = 800.0;
	
	for (float i = 0.0; i < 20.0; i++){
		rn = vec3(gl_FragCoord.xy*i, time);
		x = rand(rn) / maxdiv;
		angle = 2.0 * pi * rand(rn.yzx);		

		position += vec2(cos (angle)*x, sin(angle)*x);
		
		dist = distance (vec2(0.5,0.5), position);

		/*if (dist < 0.4){
			color.x += mix(0.0, 0.02, x*20.0);
			color.y += mix(0.0, 0.02, x*20.0);
			color.z += mix(0.0, 0.02, x*20.0);
		}*/
		
		if (position.y > 0.5+sin(time*2.0+position.x*20.0)*0.01){
			if (position.y < 0.51+sin(time*2.0+position.x*20.0)*0.01){
				color.x += mix(0.0, 0.3, x*maxdiv);
				color.y += mix(0.0, 0.3, x*maxdiv);
				color.z += mix(0.0, 0.3, x*maxdiv);
			}
		}
	}

	gl_FragColor = vec4( color, 1.0 );

}