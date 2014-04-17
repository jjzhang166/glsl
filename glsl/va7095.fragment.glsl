#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {
    
    float sum = -5.0;
    float size = resolution.x / 10.0;
    float g = 1.9195;
    int num = 0;
    float m = 0.5;
	float ctime = time*3.;
    for (int i = 0; i < 1000; ++i) {
        vec2 position = resolution / 2.0;
	float z=2.0+sin(ctime / 2.0 + float(i)/(25.0+5.0*cos(ctime/3.0)));
        position.x += sin(ctime / 2.0 +float(i)/(45.0+5.0*cos(ctime/5.0))) * resolution.x * 0.10*z;
   	position.y += sin(ctime / 2.0 +float(i)/(30.0+5.0*cos(ctime/7.0))) * resolution.y * 0.10*z;
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist, g);
    }
    
    vec4 color = vec4(0,0,0,0);
    float val = sum / 20.0;
    color = vec4(val*1.0, val*0.2, val*0.0, 1);
    gl_FragColor = vec4(color*(0.11 + sin(time*100.)*0.1) + texture2D(bb, vec2(cos(time*6000.),-sin(time*5200.))*0.01+(gl_FragCoord.xy / resolution.xy))*(0.89 - sin(time*100.)*0.1));
}