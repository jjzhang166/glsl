#ifdef GL_ES
// bobbles... need fish ;-)
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float sinRand(float seed);
float sinTime(float speed);

void main( void ) {
	vec2 op = vec2(gl_FragCoord.x,gl_FragCoord.y);
	vec2 opPercent = vec2(op.x/resolution.x,op.y/resolution.y);
	
	float r = 1.0;
	float g = 1.0;
	float b = 0.0;
	float a = 1.0;
	
	//r = opPercent.x;
	g = opPercent.x;
	b = opPercent.y*0.0;
	
	float len = 111.0;
	for(float i = 1.0; i <15.0; i+=1.0){
		vec3 p = vec3(sinRand(i*0.1*(time)*0.01),sinRand(time/i),0.01 + (i/(5.0*len)*sinTime(0.4)));
		float dx = p.x - opPercent.x;
		float dy = p.y - opPercent.y;
		float dist = sqrt(dx*dx+dy*dy);
		if(dist < p.z){
			//a = dist*1.0;
			r += 1.0 - dist*(2.0-(1.0*sinTime(1.0)));
			g += 1.0 - dist*(10.0-(1.0*sinTime(13.0)));
			b = 0.0 - dist*(8.0-(1.0*sinTime(0.0)));
		}
	}
	
	
	vec3 rgb = vec3(r,g,b);
	gl_FragColor = vec4( rgb, a );

}

float sinRand(float seed){
	return (sin(seed)+1.0) /2.0;
}

float sinTime(float speed){
	return ((sin(time)*speed)+2.0) /2.0;
}