#ifdef GL_ES
precision mediump float;
#endif

uniform float uTime;
uniform vec2 resolution;

vec3 noise(in vec2 co, in float scale)
{
	//return fract(sin(dot(vec2(14850.23435098,3239.209),vec2(594.021,168596.24))/10.0));
	return vec3(fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453)/scale);
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 cc = (uv-vec2(0.5))*vec2(1.6,1.0);
	vec3 col = vec3(0.0);
	
	float grad = 0.0;
	float z = 0.0;
	float fade = 0.0;
	vec2 star = vec2(0.0,0.0);
	vec2 blob = vec2(0.0,0.0);
	for (float i=0.0;i<1024.0;i++)
	{
		star = vec2(64.0*cos(i),-16.0*atan(i*i));
		z = mod(i*i-24.0*uTime,256.0);
		blob = star/z;
		//grad = pow(sin(cc.x*cc.y*time+cc.x*time),0.1);
		grad += (z/1280000.0)/pow(length(cc-blob),0.9);
	}
	grad+=0.4*grad*(1.0+sin(uTime*11.7));
	col = vec3(grad*2.0,grad,grad/2.0)+noise(cc*3.3,150.0);
	//col = vec3(1.0-grad,0.8-grad,1.0-grad);
	
	gl_FragColor = vec4(col,1.0);
}