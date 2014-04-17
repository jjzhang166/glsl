precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform sampler2D backbuffer;
float PI = 3.141;

// Going mad on mescalin :D

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 p = surfacePosition;
	float speed = 0.25;
	vec3 color = vec3(0.1,0.1,0.1);
	vec2 loc = vec2(
		cos(time/4.0*speed)/1.9-cos(time/2.0*speed)/3.8,
		sin(time/4.0*speed)/1.9-sin(time/2.0*speed)/3.8
	);
	float depth;
	for(int i = 0; i < 100; i+=1){
		p = vec2(p.x*p.x-p.y*p.y, 2.0*p.x*p.y)+loc;
		depth = float(i);
		if((p.x*p.x+p.y*p.y) >= 4.0) break;
	}
	//vec4 bgcol = vec4(clamp(color*depth*0.005, 0.0, 1.0), 1.0 );
	vec4 bgcol = texture2D(backbuffer, vec2(clamp(depth*0.005,0.0,0.5)+mod(time*0.3, 0.5), 0.999));
	
	bgcol.x += 0.2*(sin(position.x*PI*2.0-1.5+cos(position.y*1000.0*mouse.y)*sin(position.y+time*0.5)));
	bgcol.y += 0.2*(sin(position.x*PI*2.0-1.5+cos(position.y*100.0*mouse.x)*sin(position.y+time*0.2)));
	bgcol.z += 0.2*(sin(position.y*PI*2.0-1.5+sin(position.x*10.0*mouse.x)*sin(position.y+time*0.3)));
	bgcol = bgcol * mod(gl_FragCoord.y, 2.0);

	if (position.y > 0.992) {
		bgcol = vec4(clamp(abs(cos(position.x*2.0*PI-mouse.y)), 0.0, 1.0),
			     clamp(abs(cos(position.x*2.0*PI-mouse.x*0.01)), 0.0, 1.0),
			     clamp(abs(cos(position.x*2.0*PI+mouse.x)), 0.0, 1.0), 1.0);
	}

	gl_FragColor = bgcol;
}
