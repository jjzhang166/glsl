#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;
uniform float time;

vec4 rect1x1(vec2 v)
{
  if(-0.5<=v.x && v.x<=0.5 && -0.5<=v.y && v.y<=0.5){
	  return(vec4(1.0,1.0,0.0,1.0));
  }else{
	  return(vec4(0.0,0.0,0.0,0.0));
  }
}

vec2 o2n(vec2 v)
{
	return vec2(
		(v.x*1.6-resolution.x)/resolution.y,
		(v.y*1.6-resolution.y)/resolution.y
		)*atan(gl_FragCoord.x, gl_FragCoord.x);
}

vec2 n2o(vec2 v)
{
	return vec2(
		(v.x*resolution.y+resolution.x)*0.5,
		(v.y*resolution.y+resolution.y)*0.5
		) * atan(gl_FragCoord.x, gl_FragCoord.x);
}

vec4 neg(vec4 v)
{
	return vec4(1.0-v.r,1.0-v.g,1.0-v.b,v.a);
}

vec3 color(){ 
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec3 c;
	float cs = 4.*atan(uv.x, uv.y);
	c.r = cos(cs-1.);
	c.g = sin(cs-1.6);
	c.b = cos(cs+1.);
	return c;
}

vec4 paint(vec4 b,vec4 f)
{
	if(b.a==0.0){
		return(b);
	}else if(f.a==0.0){
		return(b*color().xyzz);	
	}else{
		return(f*1.-color().xyzz);
	}
}

vec2 rot90(vec2 v)
{
   return vec2( v.y,-v.x);	
}


void main( void )
{
	vec2 npos=o2n(gl_FragCoord.xy)+vec2(.3, .2);
	vec2 npos2=rot90(npos)/cos(sin(time*.03)+time*.1)*2.;

	vec2 opos=n2o(npos2);
	vec2 texPos = vec2(opos/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos);
	vec4 hanten = neg(zenkai);
	gl_FragColor =  paint(rect1x1(npos),hanten);
}
