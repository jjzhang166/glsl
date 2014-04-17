#ifdef GL_ES
precision mediump float;
#endif

// FaerieLights => kinglesthecat.tumblr.com
// Parent => suspended illumination by kapsy1312.tumblr.com

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main( void ) {
    
    float sum = .5;
    float size = resolution.x / 1.6;
    float g = .85;
    int num = 60;
	
	float t = time/0.9;
	
    for (int i = 0; i < 20; ++i) {
        vec2 position = resolution / 2.0;
	    if(cos(t / 1.0 + 1.0 * float(i)) > 0.0)
        position.x += sin(t / 1.0 + 1.0 * float(i)) * resolution.x * 0.25 * (1.0);
	    else
	position.x += -sin(t / 1.0 + 1.0 * float(i)) * resolution.x * 0.25 * (1.0);
		    
   //     position.y += sin(t / 1.0 + (1.0 + sin(t) * 0.2) * float(i)) * resolution.y * 0.4 * (mouse.y);
        
	    
	    position.y = position.x * 0.0 + 100.1 * float(i) ;
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist*10.0, g*0.999);
    }
    
    //vec4 color = vec4(0,0,1,1);
    float ksum = sum / float(num);
    float val = ksum * 1.3;
    vec4 color = vec4(val*0.5, val*0.2, val*0.2, 1);
    
    gl_FragColor = vec4(color);
}