#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 vtx_uv = ( gl_FragCoord.xy / resolution.xy );
	float rate = 2.0;
	vec2 pos = vtx_uv;
	pos.y = pos.y / rate;
	float t = time/3.0;
	float size = 0.02;
	
	float sum = .0;
	
	for (int i = 0; i < 10; ++i) {
	        vec2 position = vec2(0.5,0.5 / rate);
	        position.x += cos(mod(t + float(i) / 2.0, 3.141592)) / 1.8;
	        position.y += sin(20.0 * cos(float(i))) / 6.0 / rate;
	        if (abs(position.x - pos.x) < size && abs(position.y - pos.y) < size){
	        	sum += 20.;
		}
		else{
	        	sum += 0.;//2.;
		}
	        
	}
	float val = sum / float(5);
	vec4 color = vec4(val*0.8, val*0.2, val*0.4, 1);
    
	gl_FragColor = vec4(color);
	if (val == 0.0) discard;
}