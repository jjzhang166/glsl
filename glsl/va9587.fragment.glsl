#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 uv =  vec2(gl_FragCoord.x / resolution.x, gl_FragCoord.y / resolution.y);
	
	vec3 ang = vec3(-30.0,1.0,30.0);
	vec2 startPoint = vec2(0.5,0.0);
	
	vec3 rgb = vec3(0,0,0);
	
	for(int t = 0; t < 3; t++){
		for(int i = 0; i < 50; i++){
			vec2 pointAlongLine = startPoint;
			pointAlongLine.x += sin(ang[t]*sin(float(i)+time)*3.14/180.0)* (float(i)/50.0);
			pointAlongLine.y += cos(ang[t]*3.14/180.0)* (float(i)/50.0);
			float dist = distance(uv,pointAlongLine);
			if(dist < 0.09){
				rgb.x += 1.0 - dist/0.09;
				rgb.y += (1.0 - dist/0.09) * 0.3;
			}
		}
	}
	
	//rgb *= abs(sin(time*5.0));
	

	gl_FragColor = vec4( vec3( rgb.x,rgb.y,rgb.z ), 1.0 );

}