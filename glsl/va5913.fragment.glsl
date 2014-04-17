#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
uniform sampler2D bb;

// modified version of 
// http://glsl.heroku.com/e#5811.2

float distl(vec2 P, vec2 P0, vec2 P1)
{
	vec2 v = P1 - P0;
	vec2 w = P - P0;
	float b = dot(w,v) / dot(v,v);
	v *= clamp(b, 0.0, 1.0);
	return distance(w,v);
}

float noise(vec2 uv)
{
	vec2 f = fract(uv);
	//f = f*f*(3.0-2.0*f);
	uv = floor(uv);
	vec4 r = vec4(uv.x+uv.y*1e3) + vec4(0., 1., 1e3, 1e3+1.);
	r = fract(1e5*sin(r*1e-3));
	return mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);	
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy );
	
	vec4 lmd = texture2D(bb,vec2(0.95)/resolution);
	
	vec2 lm = vec2(lmd.x+lmd.z,lmd.y+lmd.w)/2.;
	
	p.x += noise(p*0.3)*10.0 - 5.0;
	p.y += noise(p*0.6)*10.0 - 5.0;
	vec3 lp = texture2D(bb,p/resolution).xyz * 0.20;
	lp += texture2D(bb,(p-vec2(1.0,0.0))/resolution).xyz * 0.20;
	lp += texture2D(bb,(p+vec2(1.0,0.0))/resolution).xyz * 0.20;
	lp += texture2D(bb,(p-vec2(0.0,1.0))/resolution).xyz * 0.20;
	lp += texture2D(bb,(p+vec2(0.0,1.0))/resolution).xyz * 0.20;
	//lp *= 0.99; 
	lp *= 1.01;
	
	
	float c = 0.0;
	
	//Right click and draw to change the brush size.
	float bsize = clamp(surfaceSize.x,1.0,128.);
	
	c = 1.5-distl(p,mouse*resolution,lm*resolution)/bsize;
	c = clamp(c,0.0,1.0);
	
	lp = max(vec3(c),lp);
	
	if( lp.x >= 0.999 || lp.y >= 0.999 || lp.z >= 0.999 )
		lp *= vec3(noise(p)/3.5, 0.16, 0.16);
	
	gl_FragColor = vec4( vec3( lp ), 1.0 );
	if(p.y < 1.5 && p.x < 1.5)
	{
		//Attempting to lessen the inaccuracy a bit.
		float mxb;
		float myb;
		float mxt;
		float myt;

		mxt = clamp((mouse.x-0.5)*2.,0.,1.); 
		myt = clamp((mouse.y-0.5)*2.,0.,1.); 
		mxb = clamp(mouse.x*2.,0.,1.); 
		myb = clamp(mouse.y*2.,0.,1.); 
		gl_FragColor = vec4( mxb, myb, mxt, myt);	
	}
}