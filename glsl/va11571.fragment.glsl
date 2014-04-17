#ifdef GL_ES
precision highp float;
#endif
 
uniform vec2 resolution;
uniform float time;
varying vec2 surfacePosition;
 
//return [0,1]
float angle(vec2 v) {
	if (v.y >= 0.0)
		return acos(v.x/length(v)) / (2.0*3.14159);
	else
		return ( (2.0*3.14159)-acos(v.x/length(v)) ) / (2.0*3.14159);
}
float angle(vec2 a, vec2 b) {
	return angle(b) - angle(a); 
}

void main(void)
{
  vec2 p = surfacePosition;//-1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
  
  float a = -0.05;
  float r = length(p); 
	//r *= ((angle(p,vec2(sin(time),cos(time)))))*3.0+1.0;
	r *= sin(time*angle(p)*2.0*3.1415);
	
  float b = 1.0 * cos ( 20.0*time + 5.00 / r);
  b = pow(b, r);
  b *= smoothstep(0.05, 0.2, 0.5*b*r);
 
  gl_FragColor = vec4(b, 0.67 * b, 0.0, 1.0);
	//gl_FragColor = vec4(angle(p));//test
}