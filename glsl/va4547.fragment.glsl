#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy);
		
	pos.x -= 0.5;	
	pos.y -= 0.5;	
	pos.x *= 2.0;
	pos.y *= 2.0;			
	
	pos.x *= (resolution.x / resolution.y);
	
	//float mx = mouse.x + 0.1;	

	float mx = 1.- ( .6 * sin(time)) + .1;

	pos *= pow(mx,4.3);

        pos.y += sin(time) * cos(time) + 2. * cos(time/2.);
//
	pos.x -= 1.18219;
	pos.y -= 0.30957;
	
	vec2 x = pos;
	for(int i = 1; i < 50 ; i++) {		
		x = vec2((x.x*x.x) - (x.y*x.y), (x.x*x.y) + (x.y*x.x)) + pos;		
  	}
	
	float color = sqrt((x.x*x.x) + (x.y*x.y));	
	
	color = clamp(color,-1.0,3.0);
        color *= mx;
	//color -= 2.0;
	//color = clamp(color,0.0,1.0);	
	
	gl_FragColor = vec4(color,color,color,1);
	
}