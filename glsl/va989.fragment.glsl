#ifdef GL_ES
precision mediump float;
#endif

//Chris Butler - @Avalix - Messing around with GLSLWorkshop making pretty things :D

//*** Flying through the time vortex ***///

//Code scavenged and reworked from verious samples

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float maxcomp(in vec3 p ) { return max(p.x,max(p.y,p.z));}
float sdBox( vec3 p, vec3 b )
{
  vec3  di = abs(p) - b;
  float mc = maxcomp(di);
  return min(mc,length(max(di,0.0)));
}

float opU( float d1, float d2 )
{
    return min(d1,d2);
}

vec4 map( in vec3 p )
{
   float MainBody = sdBox(p,vec3(0.05, 0.15,0.05));
   float light = sdBox(p + vec3(0.0,-0.16,0.0),vec3(0.015, 0.025,0.015));

   float total = opU(MainBody, light);
   vec4 res = vec4( total, 1.0, 0.0, 0.0 );

   return res;
}

vec4 intersect( in vec3 ro, in vec3 rd )
{
    float t = 0.0;
    vec4 res = vec4(-1.0);
    for(int i=0;i<64;i++)
    {
        vec4 h = map(ro + rd*t);
        if( h.x<0.002 ) 
        {
            if( res.x<0.0 )
	    {
		    res = vec4(t,h.yzw);
	    }
        }
        t += h;
    }
    return res;
}


vec3 calcNormal(in vec3 pos)
{
    vec3  eps = vec3(.001,0.0,0.0);
    vec3 nor;
    nor.x = map(pos+eps.xyy).x - map(pos-eps.xyy).x;
    nor.y = map(pos+eps.yxy).x - map(pos-eps.yxy).x;
    nor.z = map(pos+eps.yyx).x - map(pos-eps.yyx).x;
    return normalize(nor);
}

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx= ((x*3.0)+sin(t*fx)*sx) * (0.4 + 0.5 * (0.5 + sin(time) * 0.5) * 0.5);
   float yy=(y*3.0)+cos(t*fy)*sy;
   return 1.0/sqrt(xx*xx+yy*yy);
}

void main( void )
{
	vec3 finalColor = vec3(0.0);
	
	float pi = 3.1415926;
	
	float spiralDense = 0.1 + (0.5 + sin(time) * 0.5) * 0.1;
	float spiralSpeed =  2.0;
	float fireflySize = 60.0 - 15.0 * (0.5 + sin(time * 5.0) * 0.5);
	float fireflySize2 = 60.0 - 20.0 * (0.5 + sin(time * 3.0) * 0.5);
	float fireflySize3 = 60.0 - 10.0 * (0.5 + sin(time * 4.0) * 0.5);
	
	vec2 pixel = gl_FragCoord.xy + ((-0.5 + mouse.xy) * 200.0);
	vec2 position = (pixel - resolution * 0.5) / resolution.yy;
	float angleAroundPipe = atan(position.y, position.x) / (2.0 * pi) + 0.5;
	float distFromCentre = length(position);
	
	float a = ((spiralDense) / distFromCentre + time);
	
	float spiralAttenA = cos((angleAroundPipe - a) * 3.1415926 * spiralSpeed);
	float spiralAttenB = cos((angleAroundPipe - (-a * 0.05)) * 3.1415926 * spiralSpeed * 2.5);
	float spiralAttenC = cos( a * 3.1415926 * spiralSpeed * 3.0);
	
	vec3 spiralColour = mix(vec3(0.5, 0.6, 0.9), vec3(0.75, 0.8, 0.3), (0.5 + sin(time * 0.4) * 0.5) );
	vec3 spiralColourInv = mix( vec3(0.75, 0.8, 0.3), vec3(0.5, 0.6, 0.9), (0.5 + sin(time * 0.4) * 0.5) );
	vec3 spiralColourTwo = mix(vec3(0.6, 0.1, 0.1), vec3(0.5, 0.0, 0.0), (0.5 + sin(time * 0.4) * 0.5) );
	vec3 spiralColorBkgd = mix(vec3(0.05, 0.05, 0.05), vec3(0.1, 0.1, 0.1), (0.5 + sin(time * 0.1) * 0.5) );
	vec3 black = vec3(0.0,0.0,0.0);
	
	vec3 spiralFinalcolor = mix(spiralColour, spiralColorBkgd, pow(spiralAttenA, 0.7));
	spiralFinalcolor += mix(spiralColourInv, black, pow(spiralAttenB, 0.2));
	spiralFinalcolor += mix(spiralColourTwo, black, pow(spiralAttenC, 0.3));
	
	finalColor += spiralFinalcolor * clamp(distFromCentre, 0.0, 1.0);
	
	//Tardis
	vec2 p = -1.0 + 2.0 * pixel / resolution.xy;
	
	    vec3 col = vec3(0.0);
		
	    if(p.x > -0.1 && p.x < 0.1 && p.y > -0.25 && p.y < 0.25)
	    {
	
	    // light
	    vec3 light = normalize(vec3(1.0,0.8,-0.6));
	
	    float ctime = time;
		//float angle = atan(, cos(ctime));
	    // camera
	     vec3 ro = 1.2*vec3(sin(ctime),0.4 * cos(ctime*1.3),cos(ctime));//*sin(0.5*ctime));
	    
	    vec3 ww = normalize(vec3(0.0) - ro);
	    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
	    vec3 vv = normalize(cross(ww,uu));
	    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );
	
	    
	    vec4 tmat = intersect(ro,rd);
	    if( tmat.x>0.0 )
	    {
		vec3 pos = ro + tmat.x*rd;
		vec3 nor = calcNormal(pos);
	
		float dif1 = max(0.4 + 0.6*dot(nor,light),0.0);
		float dif2 = max(0.4 + 0.6*dot(nor,vec3(-light.x,light.y,-light.z)),0.0);
	
		// shadow
		//float ldis = 4.0;
		//vec4 shadow = intersect( pos + light*ldis, -light );
		//if( shadow.x>0.0 && shadow.x<(ldis-0.01) ) dif1=0.0;
	
		float ao = tmat.y;
		col  = 1.0*ao*vec3(0.2,0.2,0.2);
		col += 2.0*(0.5+0.5*ao)*dif1*vec3(1.0,0.97,0.85);
		col += 0.2*(0.5+0.5*ao)*dif2*vec3(1.0,0.97,0.85);
		col += 1.0*(0.5+0.5*ao)*(0.5+0.5*nor.y)*vec3(0.1,0.15,0.2);
	
		// gamma lighting
		col = col*0.5+0.5*sqrt(col)*1.2;
	
		vec3 matcol = vec3(
		    0.6+0.4*cos(5.0+6.2831*tmat.z),
		    0.6+0.4*cos(5.4+6.2831*tmat.z),
		    0.6+0.4*cos(5.7+6.2831*tmat.z) );
		col *= matcol;
		col *= 1.5*exp(-0.5*tmat.x);
		col *= vec3(0.2, 0.2, 0.75);
	    }
	    }
	finalColor += col;
	
	//Fireflys
	float f1 = makePoint(position.x,position.y,3.3,2.9,0.3,0.3,time) * 0.5;
	f1 += makePoint(position.x,position.y,1.5,0.3,0.4,0.2,time) * 0.5;
	f1 += makePoint(position.x,position.y,2.2,2.2,0.1,0.1,time) * 0.5;
	
	
	float f2 = makePoint(position.x,position.y,1.4,3.4,0.4,0.4,time) * 0.5;
	f2 += makePoint(position.x,position.y,2.3,3.4,0.3,0.2,time) * 0.5;
	f2 += makePoint(position.x,position.y,5.4,2.5,0.35,0.3,time) * 0.5;
	
	float f3 = makePoint(position.x,position.y,2.4,5.2,0.6,0.3,time) * 0.5;
	f3 += makePoint(position.x,position.y,4.34,2.4,0.3,0.3,time) * 0.5;
	f3 += makePoint(position.x,position.y,7.32,1.3,0.2,0.3,time) * 0.5;
	
	vec3 fireflyColorOne = vec3(f1, f2, f3) / fireflySize;
	vec3 fireflyColorTwo = vec3( f2, f1, f2) / fireflySize2;
	vec3 fireflyColorthree = vec3 (f2, f3, f3) / fireflySize3;
	
	vec3 fireflyColor = fireflyColorOne + fireflyColorTwo + fireflyColorthree;
	finalColor += fireflyColor;
	
	gl_FragColor = vec4(finalColor, 1.0);
}