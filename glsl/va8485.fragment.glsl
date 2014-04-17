#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float viewAngle = 1.0;
float speed = 0.2;
float rate = 1.2;
float baseamp = 0.32;

void main(void)
{
  vec2 p = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
  p = vec2(distance(p, vec2(0, 0)), sin(atan(p.x, p.y)*10.0));
  float x = speed * viewAngle * time + rate * p.x;
  float base = (5.0*cos(x*10.0 + time)) * (1.2 + 1.5*sin(x*4.95 + time));
  float z = fract(0.05*x);
  z = max(z, 100000.0-z);
  z = pow(z, 50.0);
  float pulse = exp(-10.0 * z);
	
	
/*	
  float r = sin(gl_FragCoord.y + time) - 0.2,
	g = sin(0.04 * gl_FragCoord.x + time) - 0.5,
	b = cos(gl_FragCoord.x / gl_FragCoord.y + time);
*/	
  float r = sin(gl_FragCoord.x / 1000.0 + sin(time)),
	g = cos(gl_FragCoord.y / 1000.0 + time),
	b = 0.01;
	
	
  vec4 ecg_color = vec4(r, g, b, 1.0);
  gl_FragColor = pow(1.0-abs(p.y-(baseamp*base+pulse-0.5)), 16.0) * ecg_color;
}