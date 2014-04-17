// rotwang: like this, @mod* little changes color, jags, tempo, scale
#ifdef GL_ES
precision mediump float;
#endif

//tigrou (ind) 2012.08.30 (tigrou dot ind at gmail.com)
uniform float time;
uniform vec2 resolution;

float wheel(vec2 p,float t)
{
	
  vec2 m = vec2(mod(p.x,2.0)-1.0, mod(p.y,2.0)-1.0);
  
	float tata= t+1.0 * atan(abs(m.y),abs(m.x));
  float a = pow(abs(sin(tata)), 16.0);
  float e = 0.35 + min(a * 0.28, 0.26);
  float d = length(m);
	
  return d < e && d > 0.3 ? 1.0 - abs(sin(tata))*0.5  : 0.0;   
}


const float PI = 3.14159265;
void main( void ) {

	vec2 p = (gl_FragCoord.xy / min(resolution.x, resolution.y))-0.5;
        p *= 2.0;
	
        float t = sin(time)*4.0;
	
	float r = wheel(p, t)+wheel(p+vec2(1.0,1.0), t);
	float g = wheel(p+vec2(1.0,0.0),-t+PI/2.0);
        float b = wheel(p+vec2(0.0,1.0),-t-PI/2.0)+g;
	
	gl_FragColor = vec4(r,(r+b),b, 1.0);
}
