//MG

// little change by Anoki
#ifdef GL_ES
precision mediump float;
#endif
#define BLU_SPEED	0.01
#define RED_SPEED	0.2
#define GREEN_SPEED	1.2

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	vec2 pos=(gl_FragCoord.xy/resolution.y);
	pos.x-=resolution.x/resolution.y/2.0;
	pos.y-=0.5;
	vec2 mse;
	mse.x+=(mouse.x-0.5)*resolution.x/resolution.y;
	mse.y+=mouse.y-0.5;

	for (float i = 1.0; i <= 14.0; i++) {
		float phi = 0.002;
		float t = time;
		if (pos.x < 0.0) {
			t = t * -1.0;
		}
		
		float fx = exp(phi * i * abs(pos.x) * 1200.0) * sin(i * time/4.0 + abs(pos.x) * 5.0) / 20.0 * cos(i);
		float dist = abs(pos.y-fx)*25.0;
		gl_FragColor+=vec4(0.1/dist, 0.2/dist, 0.3/dist,1.0);
		
	}
	
	vec2 p = gl_FragCoord.xy;
	float dis = distance(p, mouse * resolution);
	vec3 color = vec3(0.05,0.075,0.05);
	color -= dis * 0.0035 + (sin(time)/5.0);
	gl_FragColor += vec4(color, 1.0);
	/*
	float fx=sin(pos.x*5.0+time*BLU_SPEED+mse.x*BLU_SPEED*5.0)/8.0;
	float dist=abs(pos.y-fx)*80.0;
	gl_FragColor+=vec4(0.5/dist,0.5/dist,1.25/dist,1.0);
	
	fx=cos(pos.x*pos.x+time*RED_SPEED*2.0+mse.x*RED_SPEED*5.0)/15.0;
	dist=abs(pos.y-fx)*80.0;
	gl_FragColor+=vec4(1.25/dist,0.5/dist,0.5/dist,1.0);
	
	fx=sin(pos.x/2.0+time*GREEN_SPEED+mse.x*GREEN_SPEED*2.5)/4.0;
	dist=abs(pos.y-fx)*80.0;
	gl_FragColor+=vec4(0.25/dist,1.25/dist,0.25/dist,1.0);
	*/
	
	if (pos.y<=-0.2) {
		gl_FragColor+=vec4(abs(pos.y+0.2),abs(pos.y+0.2),abs(pos.y+0.2),1.0);
	}
}