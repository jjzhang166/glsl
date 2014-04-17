#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TAU 6.28318

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 arc(vec2 pos,vec4 btrir,float ang,vec2 p,vec3 color);

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {

	vec2 p = gl_FragCoord.xy;
	
	vec2 q = p.xy / resolution.xy;
	
	vec3 color = texture2D(backbuffer, q).rgb / 1.01;
	
	if (color.r< 64./255.)
		color.r -= 1./255.;
	if (color.g<64./255.)
		color.g-= 1./255.;
	if (color.b<64./255.)
		color.b-= 1./255.;
	
	for(float i = 4.0;i < 32.0;i++)
	{
		float j = i-2.0;
		color += arc(resolution/2.,vec4(0.0,PI/40.,j*16.0,(j+1.0)*16.0),time*(j/64.0),p, hsv2rgb(i/28.0,1.0,1.0));
	}
	
	gl_FragColor = vec4(vec3(color),1.0);
}

vec3 arc(vec2 pos,vec4 btrir,float ang,vec2 p,vec3 color)
{
	vec2 c = resolution/2.;
	
	float d = distance(p,vec2(c));
	
	float a = atan(p.x-c.x,p.y-c.y)+PI+ang;
	
	a = mod(a,TAU);
	
	if(a > btrir.x && a < btrir.y && d > btrir.z && d < btrir.w)
	{
		float diff = d-btrir.z;
		float rtrn = smoothstep(0.0,1.0,pow(sin(diff/16.*PI),0.25));
		
		float eb = 32.0;
		if(a < btrir.x+(PI/eb))
		{
			rtrn *= smoothstep(0.0,1.0,a/(PI/eb));
		}
				
		if(a > btrir.y-(PI/eb))
		{
			float ad = a - (btrir.y-(PI/eb));
			rtrn *= smoothstep(1.0,0.0,ad/(PI/eb));
		}
		return color*rtrn;
	}
	
	return vec3(0.0);
}
