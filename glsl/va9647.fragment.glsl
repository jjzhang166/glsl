//trying to make a sort of video feedback
//this sucks and needs work


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}

void main( void ) 
{
	vec4 col = vec4(0.0);
	
	if(length(mouse*resolution-gl_FragCoord.xy) < 30.)
	{
		col = vec4(nrand3(vec2(time,-time)), 1.0);
		//col=vec4(0.0);
	} else {
		
		vec2 Delta = vec2(1.0)/resolution;
		vec2 uv = gl_FragCoord.xy / resolution;
	
		//move uv towards center so it causes a zoom in effect
		//gl_fragcoord goes from 0,0 lower left to imagesizewidth,imagesizeheight at upper right
		float deltax = gl_FragCoord.x-resolution.x/2.0;
		float deltay = gl_FragCoord.y-resolution.y/2.0;
		//float angleradians = atan2(deltay,deltax) * 180.0/3.14159265;
		//float angleradians = atan(deltay,deltax) * 90.0;
		float angleradians = atan(deltay,deltax)+3.14159265;
		//now walk the vector/angle between current pixel and center of screen to get pixel to average around
		float zoomrate=1.0;
		float newx = gl_FragCoord.x + cos(angleradians)*zoomrate;
		float newy = gl_FragCoord.y + sin(angleradians)*zoomrate;
	
		uv = vec2(newx,newy)/resolution;
	
		// current pixel and 8 neighbors
		vec4 L = texture2D(backbuffer, uv+vec2(-Delta.x, 0.0));
		vec4 R = texture2D(backbuffer, uv+vec2(Delta.x, 0.0));
		vec4 U = texture2D(backbuffer, uv+vec2(0.0, Delta.y));
		vec4 D = texture2D(backbuffer, uv+vec2(0.0, -Delta.y));
		vec4 UL = texture2D(backbuffer, uv+vec2(-Delta.x, Delta.y));
		vec4 UR = texture2D(backbuffer, uv+vec2(Delta.x, Delta.y));
		vec4 LL = texture2D(backbuffer, uv+vec2(-Delta.x, -Delta.y));
		vec4 LR = texture2D(backbuffer, uv+vec2(Delta.x, -Delta.y));
		vec4 C = texture2D(backbuffer, uv);
	
		//average blur
		float rblur = (L.r+R.r+U.r+D.r+UL.r+UR.r+LL.r+LR.r+C.r)/9.0;
		float gblur = (L.g+R.g+U.g+D.g+UL.g+UR.g+LL.g+LR.g+C.g)/9.0;
		float bblur = (L.b+R.b+U.b+D.b+UL.b+UR.b+LL.b+LR.b+C.b)/9.0;

		//sharpen
		float sharpamount=1.5;
		float rsharp = (rblur+sharpamount*(rblur-C.r));;
		float gsharp = (gblur+sharpamount*(gblur-C.g));;
		float bsharp = (bblur+sharpamount*(bblur-C.b));;
		
		/*
		float rtot=rsharp-rblur;
		float gtot=gsharp-gblur;
		float btot=bsharp-bblur;
		*/
		
		/*
		float rtot=rblur-rsharp+0.1;
		float gtot=gblur-gsharp+0.1;
		float btot=bblur-bsharp+0.1;
		*/
		
		
		float rtot=rsharp;
		float gtot=gsharp;
		float btot=bsharp;
		
		
		//add some random noise
		/*
		rtot=rtot+nrand3(vec2(-time,time)).r;
		gtot=gtot+nrand3(vec2(-time,time)).g;
		btot=btot+nrand3(vec2(-time,time)).b;
		*/
		
		/*
		if (rtot>=1.0) { rtot=rtot-1.0; }
		if (gtot>=1.0) { gtot=gtot-1.0; }
		if (btot>=1.0) { btot=btot-1.0; }
		*/
		
		col=vec4(rtot,gtot,btot,1.0);
				
		//col=mix(col,C.r,0.5);
		col=(col+C.r)/2.0;
	}

    gl_FragColor = vec4(col);
}