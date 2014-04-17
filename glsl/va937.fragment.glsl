#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;

void main() {
	
//    vec2 pos = ( (gl_FragCoord.xy * abs(sin(time*0.1) + 1.0)) / (resolution.xy) );
    vec2 p = gl_FragCoord.xy;
    p.x -= 300.0;
    p.y += 100.0;
    vec2 pos = ( (p.xy ) / (resolution.xy) );
    //pos.x += sin(time*0.5)*0.3;

    //pos.y += sin(time*1.7*0.5)*0.2;
    pos *= .5;

    vec2 z;
    z.x = pos.x;
    z.y = pos.y;
    int i;
    for(int i=0; i<128; i++) {
        float x = (z.x * z.x - z.y * z.y + sin(time)*0.01) + 0.34;
        float y = (z.y * z.x + z.x * z.y + cos(time*1.442)*0.01) - 0.40;

        if((x * x + y * y) > 40.0) break;
        z.x = x;
        z.y = y;
    }

    float color = (float(i) / (128.0));
    float red = cos((1.0-color)*1.56753) * 0.6;
    float green = (color * cos(pos.x*sin(time)*.6) * sin(pos.y*sin(time)*1.9) + sin(pos.x*sin(time)*1.3) * sin(pos.y*sin(time)*.2)) * 1.;
    float blue = (color * cos(pos.x*sin(time)*.2) * sin(pos.y*sin(time)*.5) + sin(pos.x*sin(time)*.3) * sin(pos.y*sin(time)*1.2)) * 20.;
    red = max(0.0, min(1.0, red));
    green = max(0.0, min(1.0, green));
    blue = max(0.0, min(1.0, blue));
    gl_FragColor = vec4(red, green, blue, 1.0)*0.7;
}