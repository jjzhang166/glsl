#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

// Cmen.
// Crappy port of some SDL 'Plasma' example/.

void main(void)
{
    vec2 pos = gl_FragCoord.xy / resolution.xy;
  
    /*
	u = x*cos(2*r) - y*sin(2*r)
	v = y*cos(2*r) + x*sin(2*r)	
    */
    
    float d = sqrt(pos.x * pos.x + pos.y * pos.y);
    float a = atan( pos.y, pos.x );
    vec2 uvPos = vec2((pos.x * cos(d) - pos.y * sin(d)), (pos.y * cos(d) + pos.x * sin(d)));
  

    
    float c1 = sin(uvPos.x / 0.25 + time + uvPos.y / 1.0);
    float c2 = sqrt(sin(0.8 * time) * 0.5 - uvPos.x + 0.5) * (sin(0.8 * time) * .5 - uvPos.x + 0.5) + (cos(1.2 * time) * 0.5 - uvPos.y + 0.5) * (cos(1.2 * time) * 0.5 - uvPos.y + 0.5);
    float c3 = (c1 + c2) / 2.0;
  
    float cm1 = 1.0 - (sin(3.14 * 2.0 * c1) + 1.0) * 0.5;
    float cm2 = sin(3.14 * 2.0 * c2 / 0.5) * 1.75;
    float cm3 = 1.0 - cm1;
    
    gl_FragColor = vec4(cm1,cm2,cm3,1.0);
}