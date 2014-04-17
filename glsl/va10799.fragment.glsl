#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;

vec4 rect1x1(vec2 v)
{
  if(-0.5<v.x && v.x<0.5 && -0.5<v.y && v.y<0.5){
	  return(vec4(1.0,0.0,0.0,1.0));
  }else{
	  return(vec4(0.0,0.0,0.0,0.0));
  }
}

vec2 o2n(vec2 v)
{
	return vec2(
		(v.x*2.0-resolution.x)/resolution.y,
		(v.y*2.0-resolution.y)/resolution.y
		);
}

vec2 n2o(vec2 v)
{
	return vec2(
		(v.x*resolution.y+resolution.x)*0.5,
		(v.y*resolution.y+resolution.y)*0.5
		);
}

vec4 akaki(vec4 v)
{
	if(v.r==1.0 && v.g==0.0 && v.b==0.0)
	{
		return vec4(1.0,1.0,0.0,v.a);
	}

	if(v.r==1.0 && v.g==1.0 && v.b==0.0)
	{
		return vec4(1.0,0.0,0.0,v.a);
	}
	return vec4(1.0-v.r,1.0-v.g,1.0-v.b,v.a);
}


vec4 paint(vec4 b,vec4 f)
{
	if(b.a==0.0){
		return(b);
	}else if(f.a==0.0){
		return(b);	
	}else{
		return(f);
	}
}

vec2 rotp90(vec2 v)
{
   return vec2( v.y,-v.x);	
}

vec2 rotm90(vec2 v)
{
   return vec2( -v.y,v.x);	
}

void main( void )
{
	vec2 npos=o2n(gl_FragCoord.xy);
	vec2 npos2=rotp90(npos)*1.4+vec2(0.2,0.2);
	
	vec2 opos=n2o(npos2);
	vec2 texPos = vec2(opos/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos);
	vec4 hanten = akaki(zenkai);

	vec2 npos3=rotm90(npos)*4.0+vec2(1.5,1.5);

	vec2 opos3=n2o(npos3);
	vec2 texPos3 = vec2(opos3/resolution);
	vec4 zenkai3 = texture2D(backbuffer, texPos3);
	vec4 hanten3 = akaki(zenkai3);
	
	gl_FragColor = paint(paint(rect1x1(npos),hanten),hanten3);
}
