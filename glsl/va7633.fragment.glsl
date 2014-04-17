#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float noise(vec3 p) //Thx to Las^Mercury
{
	vec3 i = floor(p);
	vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
	vec3 f = cos((p-i)*acos(-1.))*(-.5)+.5;
	a = mix(sin(cos(a)*a),sin(cos(1.+a)*(1.+a)), f.x);
	a.xy = mix(a.xz, a.yw, f.y);
	return mix(a.x, a.y, f.z);
}

//-----------------------------------------------------------------------------
// Scene/Objects
//-----------------------------------------------------------------------------
float sphere(vec3 p, vec4 spr)
{
	return length(spr.xyz-p) - spr.w;
}

float fire(vec3 p)
{
	float d= sphere(p*vec3(.8,1.,1.), vec4(-1.0,-2.,.0,1.));
	return d+(noise(p+vec3(time*3.,.0,.0))+noise(p*4.)*.5)*.25*(p.x) ;
}
//-----------------------------------------------------------------------------
// Raymarching tools
//-----------------------------------------------------------------------------
float scene(vec3 p)
{
	return min(100.-length(p) , abs(fire(p)) );
}



vec4 Raymarche(vec3 org, vec3 dir)
{
	float d=0.0;
	vec3  p=org;
	float glow = 0.0;
	float eps = 0.02;
	bool glowed=false;
	for(int i=0; i<32; i++)
	{
		d = scene(p) + eps;
		p += d * dir;
		if( d>eps )
		{
			if( fire(p) < .0)
				glowed=true;
			if(glowed)
       			glow = float(i)/64.;
		}
	}
	return vec4(p,glow);
}

void main( void )
{
	
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	//suPos -= vec2((resolution.x/resolution.y)/2.0, 0.0);//shift origin to center
	
	uPos.x -= 0.0;
	uPos.y -= 0.5;
	
	vec3 color = vec3(0.0);
	float vertColor = 2.0;
	
	// MAIN LASER
	if(uPos.x < 1.0)
	{
		float t = time * (0.9);
	
		//uPos.y += sin( uPos.x*i + t+i/2.0 ) * 0.1;
		float fTemp = abs(1.0 / pow(uPos.y, 2.0) / 760.0);
		vertColor += fTemp;
		//color += vec3( fTemp*(10.0-i)/10.0, fTemp*i/10.0, pow(fTemp,1.5)*1.5 );
		color += vec3( fTemp*0.15*(uPos.x*1.5+0.3)*1.0, (fTemp*1.+0.)*(uPos.x+0.3)*1.0, fTemp*0.15*(uPos.x*1.5+0.3)*1.0);
	}
	
	// Distorted ball
	if(uPos.x > 0.8)
	{
			
	}
		
	// IMPACT
	vec2 v = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	v.x *= resolution.x/resolution.y;
	vec3 org = vec3(-3.4,-2.,5.);
	vec3 dir   = normalize(vec3(v.x,v.y*1.6,-2.5));
	vec4 p = Raymarche(org,dir);
	float glow = p.w;
	vec4 midWhite = mix(vec4(0.), mix(vec4(1.0), vec4(0.), abs(p.y)*0.001), pow(glow*2., 2.));
	vec4 impact = mix(vec4(0.), mix(vec4(.6,1.,.1,1.),vec4(.1,1.,.1,1.),p.x*.04+0.4), pow(glow*2.,2.)) + midWhite;
	
	vec4 color_final = vec4(color, 1.0) + impact*1.;
	gl_FragColor = color_final;
}