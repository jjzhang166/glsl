//trying to make a sort of video feedback
//this sucks and needs work


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,float t){return inv(p+0.99*sin(t*0.9)) - inv(p+0.99*cos(t*0.9));}

const float a=0.3;
const float b=0.4;
void mandelbrot(void)
{    
 vec2 p = 2.0 *( gl_FragCoord.xy / resolution.xy)- 2.0 ;
 	p.x*=resolution.x/resolution.y;
 	float tempo=((cos(time*0.3)*0.0314+0.0314)*(b-a)/0.0628+a);	
 	for(int i=0;i<10;i++){
 	 p=(fonc(mu(p,p),tempo));}
 	 p=clamp(p,0.1,1.);
 	gl_FragColor =vec4(sin(p.x*p.y),sin(1.0/(p.y*p.y)),1.0-exp(-p.x*p.y),1.);
}

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
		float angleradians1 = atan(deltay,deltax) * 180.0/3.14159265;
		//float angleradians = atan(deltay,deltax) * 90.0;
		float angleradians0 = atan(deltay,deltax)+3.14159265*1.5;
		
		float angleradians = mix(angleradians0, angleradians1, 512.99); // woot!
		
		//now walk the vector/angle between current pixel and center of screen to get pixel to average around
		float zoomrate=.60;
		float newx = gl_FragCoord.x + cos(angleradians)*zoomrate;
		float newy = gl_FragCoord.y + sin(angleradians)*zoomrate;
	
		uv = vec2(newx,newy)/resolution;
	
		// current pixel and 8 neighbors
		vec4 L = texture2D(backbuffer, uv+vec2(-Delta.x, 0.0));
		vec4 R = texture2D(backbuffer, 0.1*-L.xy + uv+vec2(Delta.x, 0.0));
		vec4 U = texture2D(backbuffer, 0.1*-R.xy + uv+vec2(0.0, Delta.y));
		vec4 D = texture2D(backbuffer, 0.1*-U.xy + uv+vec2(0.0, -Delta.y));
		vec4 UL = texture2D(backbuffer, 0.1*-D.xy + uv+vec2(-Delta.x, Delta.y));
		vec4 UR = texture2D(backbuffer, 0.1*-UL.xy + uv+vec2(Delta.x, Delta.y));
		vec4 LL = texture2D(backbuffer, 0.1*-UR.xy + uv+vec2(-Delta.x, -Delta.y));
		vec4 LR = texture2D(backbuffer, 0.1*-LL.xy + uv+vec2(Delta.x, -Delta.y));
		vec4 C = texture2D(backbuffer, 0.01 * cos(mouse + 1.)* LR.xy + uv);
	
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
		
		
		float rtot=rsharp*C.g;
		float gtot=gsharp*C.b;
		float btot=bsharp*C.r;
		
		
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
				
		col=mix(col, C, dot(C,col)*.981);
	}

    gl_FragColor = vec4(col);
}