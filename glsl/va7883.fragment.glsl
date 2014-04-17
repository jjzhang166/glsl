#ifdef GL_ES 
precision mediump float; 
#endif 
 
uniform vec2  resolution; 
uniform float time; 
 
const int num_x = 5; 
const int num_y = 5; 
float w = resolution.x; 
float h = resolution.y; 
  
void main() { 
	float size = sin(time * 10.0) + 3.0; 
	float intval_x = w / float(num_x); 
	float intval_y = h / float(num_y); 
	float color = 0.0; 
	for(int i = 0; i < num_x; i++) { 
		for(int j = 0; j < num_y; j++) { 
			float x = intval_x * float(i) + (w * (sin(time))/2.0) / 5.0;
			float y =  intval_y * float(j) + (h * (cos(time))/2.0) / 3.0;
			vec2 pos = vec2(x, y);
			float dist = length(gl_FragCoord.xy - pos); 
			color += pow(size/dist, 2.0); 
		} 
	} 
	gl_FragColor = vec4(vec3(color), 1.0); 	 
}
