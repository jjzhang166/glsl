// Electrocardiogram Effect
// Imported from http://www.geeks3d.com/20111223/shader-library-electrocardiogram-effect-glsl/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float viewAngle = sin(1.0 + time) + 1.;
float speed = sin(time) +1.0;
float rate = sin(time)+15.0;
float baseamp = sin(time)+0.10;

void main(void)
{
  vec2 p = sin(time)+-1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
  vec2 op = sin(time)+p;
  p = vec2(distance(p, vec2(0, 0)), sin(atan(p.x, p.y)*10.0));
  float x = sin(time)+speed * viewAngle * time + rate * p.x;
  float base = (0.1 + 5.0*cos(x*1.7 + time)) * (1.37 + 0.5*sin(x*19.95 + time));
  float z = sin(time)+fract(0.05*x);
  z = sin(max(z, 100.0-z) + time) + 1.;
  z = sin(pow(z, 50.0)+ time) + 1.;
  float pulse = sin(time)+exp(-1000000.0 * z);
  vec4 ecg_color = vec4(0.3, 1.0, 0.4, 1.0);
  vec4 c = pow(1.0-abs(p.y-(baseamp*base+pulse-0.5)), 16.0) * ecg_color;
  gl_FragColor = sin(time)+c;
}