#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = 0.0;
    float size = resolution.x / 0.2;
    float g = 1.45;
    int num = 10;
	for (float n = 0.1; n < 0.9; n+= 0.1) {
    for (int i = 0; i < 36; ++i) {
        vec2 position = (resolution / 2.0) * 1.0;
        position.x += sin(time / (n*1000.0) * float(i))                        * resolution.x * n*0.6;
        position.y += cos(time / (n*10000.0) * float(i))   * resolution.y * n*0.6;
        
        float dist = length(gl_FragCoord.xy - position);
        //if(dist < 5.0) g+= 1.9;
	//g = mod(dist, 50.0);
        sum += size/pow(dist, g);
    }
}
	

    
    vec4 color = vec4(0,0,0,1);
    float val = sum;sum / float(num);
	val*= 0.001;
    color = vec4(vec3(val), 1.5);
    
    gl_FragColor = vec4(color);
}