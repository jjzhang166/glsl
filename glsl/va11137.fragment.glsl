#ifdef GL_ES
precision mediump float; 
#endif
uniform float time;
uniform vec2 mouse;
varying vec2 surfacePosition;

#define maxiter 100

//############################################## HEART
vec3 mainHeart(vec2 p)
{
	p += - vec2(0.5,0.55);
	p *= 1.3;
	p.y -= 0.25;
	
	// background color
	vec3 bcol = vec3(0.4,1.0,0.7-0.07*p.y)*(1.0-0.25*length(p));
	
	
	// animate
	float tt = mod(time,0.5)/0.5;
	float ss = pow(tt,0.2)*0.5 + 0.5;
	ss -= ss*0.2*sin(tt*30.0)*exp(-tt*4.0);
	p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);
   

	// shape
	float a = atan(p.x,p.y)/3.141593;
	float r = length(p);
	float h = abs(a);
	float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

	// color
	float s = 1.0-0.5*clamp(r/d,0.0,1.0);
	s = 0.75 + 0.75*p.x;
	s *= 1.0-0.25*r;
	s = 0.5 + 0.6*s;
	s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
	vec3 hcol = vec3(1.0,0.5*r,0.3)*s;
	
	vec3 col = mix( bcol, hcol, smoothstep( -0.01, 0.01, d-r) );

	return col;
}

//############################################## 7segment

const int d_tt = 0x01;
const int d_tr = 0x02;
const int d_tl = 0x04;
const int d_dd = 0x10;
const int d_dr = 0x20;
const int d_dl = 0x40;
const int d_cc = 0x88;

float thickness = 0.001;

float line(vec2 p, vec2 pa, vec2 pb ) {
	float d = distance(p, pa) + distance(p, pb) - distance(pa, pb);
	return 1.0-step(thickness, d);
}

float digit7(vec2 p, int spec, vec2 offset, vec2 size) {
	float d = 0.0;
	if ( spec >= d_cc ) { spec -= d_cc; d += line(p, offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_dl ) { spec -= d_dl; d += line(p, offset                                 , offset + vec2 ( .0     , size.y * .5 ) ); }
	if ( spec >= d_dr ) { spec -= d_dr; d += line(p, offset + vec2 ( size.x , .0 )          , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_dd ) { spec -= d_dd; d += line(p, offset                                 , offset + vec2 ( size.x , .0          ) ); }
	if ( spec >= d_tl ) { spec -= d_tl; d += line(p, offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( .0     , size.y      ) ); }
	if ( spec >= d_tr ) { spec -= d_tr; d += line(p, offset + vec2 ( size.x , size.y * .5 ) , offset + size ); }
	if ( spec >= d_tt ) { spec -= d_tt; d += line(p, offset + vec2 ( .0     , size.y )      , offset + size ); }
	return d;
}
float digit(vec2 p, float val, vec2 offset, vec2 size) {
	val = fract(val/10.0);
	// Ugly bisect	
	if ( val < 0.5 ) {
		if ( val < 0.3 ) {
			if ( val < 0.1 )            return digit7(p, 0x77 , offset , size ); //0
			else if ( val < 0.2)        return digit7(p, 0x22  , offset , size ); //1
			else                        return digit7(p, 0xdb , offset , size ); //2
		} else {
			if ( val < 0.4 )            return digit7(p, 0xbb  , offset , size ); //3
			else               	    return digit7(p, 0xae  , offset , size ); //4
		}
	} else {
		if ( val < 0.8 ) {
			if ( val < 0.6 )            return digit7(p, 0xbd  , offset , size ); //5
			else if ( val < 0.7)        return digit7(p, 0xfd , offset , size ); //6
			else                        return digit7(p, 0x23  , offset , size ); //7
		} else {
			if ( val < 0.9 )            return digit7(p, 0xff , offset , size ); //8
			else               	    return digit7(p, 0xbf  , offset , size ); //9
		}
	}
}
float show5(vec2 p, float val, vec2 offset, vec2 size) {
	float d = 0.0;
	const int digits = 5;
	for(int i=0; i<digits; i++)  
		d += digit(p, val/pow(10.0,float(i)), offset+vec2(-float(i)*size.x - 0.03*float(i),0.0), size);
	return d;
}
//##############################################
void main( void )
{
	vec2 z = vec2(0.0, 0.0);
	float p = 0.0;
	float dist = 1e20;
	int iUsed;
	for (int i=0; i<maxiter; ++i)
	{
		iUsed = i;
		z = vec2(z.x*z.x-z.y*z.y, z.x*z.y*2.0) + surfacePosition + (mouse-0.5)*2.0;
		// NOTE TO AUTHOR: pull out the root, distance squared is an equivalent metric.
		p = dot(z,z);
		if (p > 4.0)
			break;
		if (p < dist)
			dist = p;
	}
	
	dist = abs(sqrt(dist)*4.0-1.2);
	
	vec3 color;
	color += vec3(dist*dist/1.0, dist*dist*dist/1.9, dist/0.7);
	//color += sin(dist*z.x*z.y+time);
	if (sin(time*0.5)<-0.7)
		color += mainHeart(fract(z*5.0))*0.5;
	else if (sin(time*0.5)<0.7)
		color += mainHeart((z*5.0))*0.5;
	color += show5((z*1.0), time, vec2(0,0), vec2(0.1,0.1));
	
	gl_FragColor.xyz = color;
	gl_FragColor.w = 1.0;
}