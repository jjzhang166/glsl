#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 position;

float addLight (vec2 pos)
{
	float dist = distance(position, pos);
	float a    = pow((1.0 / dist) * 0.1,1.0);
	float lcon = a*0.02;

	
	float contr = lcon;
	
	return contr;
}

void main( void ) {

	position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	
	for(int y = 0; y < 10; y ++) {
		for(int x = 0; x < 10; x++ ){
			float _a = float(y);
			float _b = float(x);
			
			color += addLight(vec2(_b*0.1*sin(time*2.0)*1.0,_a*0.1*cos(time*2.0)));
		}
	}
	
	//color += addLight(vec2(0.5, 0.5));


	gl_FragColor = vec4(color*0.5*sin(time*2.0),clamp(color,0.5,0.8),color*cos(time*5.0), 1.0);

}