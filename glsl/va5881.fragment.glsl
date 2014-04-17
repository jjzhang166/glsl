#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
uniform sampler2D bb;

float distl(vec2 P, vec2 P0, vec2 P1)
{
     vec2 v = P1 - P0;
     vec2 w = P - P0;
     float c1 = dot(w,v);
     if ( c1 <= 0. )
          return length(P-P0);
     float c2 = dot(v,v);
     if ( c2 <= c1 )
          return length(P-P1);
     float b = c1 / c2;

     vec2 Pb = P0 + b * v;
     return length(P-Pb);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy );
	
	vec4 lmd = texture2D(bb,vec2(0.95)/resolution);
	
	vec2 lm = vec2(lmd.x+lmd.z,lmd.y+lmd.w)/2.;
	
	vec3 lp = texture2D(bb,p/resolution).xyz;
	
	float c = 0.0;
	
	//Right click and draw to change the brush size.
	float bsize = clamp(surfaceSize.x,1.0,256.);
	
	c = 1.-distl(p,mouse*resolution,lm*resolution)/bsize;
	c = clamp(c,0.0,1.0);
	
	lp = max(vec3(c),lp);
	
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