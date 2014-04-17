// Trying to implement http://www.iquilezles.org/www/articles/warp/warp.htm

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

// -------------------------------------------------------------------------------
//
struct Result
{
	float val;
	vec2 q;
	vec2 r;
};

// -------------------------------------------------------------------------------
//	
vec3 RGBToHSL(vec3 color)
{
    vec3 hsl = vec3(0.0, 0.0, 0.0); // init to 0 to avoid warnings ? (and reverse if + remove first part)

    float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
    float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
    float delta = fmax - fmin;             //Delta RGB value

    hsl.z = (fmax + fmin) / 2.0; // Luminance

    if (delta == 0.0)       //This is a gray, no chroma...
    {
        hsl.x = -1.0;    // Hue
        hsl.y = 0.0;    // Saturation
    }
    else                    //Chromatic data...
    {
        if (hsl.z < 0.5)
            hsl.y = delta / (fmax + fmin); // Saturation
        else
            hsl.y = delta / (2.0 - fmax - fmin); // Saturation

        float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
        float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
        float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;

        if (color.r == fmax )
            hsl.x = deltaB - deltaG; // Hue
        else if (color.g == fmax)
            hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
        else if (color.b == fmax)
            hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue

        if (hsl.x < 0.0)
            hsl.x += 1.0; // Hue
        else if (hsl.x > 1.0)
            hsl.x -= 1.0; // Hue
    }

    return hsl;
}

// -------------------------------------------------------------------------------
//
float HueToRGB(float f1, float f2, float hue)
{
    if (hue < 0.0)
        hue += 1.0;
    else if (hue > 1.0)
        hue -= 1.0;
    float res;
    if ((6.0 * hue) < 1.0)
        res = f1 + (f2 - f1) * 6.0 * hue;
    else if ((2.0 * hue) < 1.0)
        res = f2;
    else if ((3.0 * hue) < 2.0)
        res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
    else
        res = f1;
    return res;
}

// -------------------------------------------------------------------------------
//
vec3 HSLToRGB(vec3 hsl)
{
    vec3 rgb;

    if (hsl.y == 0.0)
        rgb = vec3(hsl.z); // Luminance
    else
    {
        float f1, f2;

        if (hsl.z < 0.5)
            f2 = hsl.z * (1.0 + hsl.y);
        else
            f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);

        f1 = 2.0 * hsl.z - f2;

        rgb.r = HueToRGB(f1, f2, hsl.x + (1.0/3.0));
        rgb.g = HueToRGB(f1, f2, hsl.x);
        rgb.b = HueToRGB(f1, f2, hsl.x - (1.0/3.0));
    }

    return rgb;
}

// -------------------------------------------------------------------------------
//	
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

// -------------------------------------------------------------------------------
//
float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

// -------------------------------------------------------------------------------
//
float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.05*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.225*noise( p );
    return f/0.984375;
}

/*
float pattern( vec2 p )
{
	
//    vec2 q = vec2( fbm( p + vec2(1.0,0.2) ),
//                     fbm( p + vec2(5.2,1.3) ) );

//      return fbm( p + 4.0*q );

	vec2 q = vec2( fbm( p + vec2(0.0,0.0) ),
                     fbm( p + vec2(5.2,1.3) ) );

      vec2 r = vec2( fbm( p + 4.0*q + vec2(1.7,9.2) ),
                     fbm( p + 4.0*q + vec2(8.3,2.8) ) );

      return fbm( p + 4.0*r );
}
*/

// -------------------------------------------------------------------------------
//
 Result pattern( vec2 p )
  {
	 Result res;
     
	res.q.x = fbm( p + vec2(0.0,0.0) + time / 20.0);
        res.q.y = fbm( p + vec2(5.2,1.3) + time /100.0);
        res.r.x = fbm( p + 4.0*res.q + vec2(1.7,9.2) + time/2.0 );
        res.r.y = fbm( p + 4.0*res.q + vec2(8.3,2.8) + time / 3.0 );
 
	res.val = fbm( p + 4.0*res.r );
	  
	//res.val = fbm( p + fbm(p+time/20.0) );
	  
      return res;
  }

// -------------------------------------------------------------------------------
//
void main(void)
{
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0 * q;
    
	Result tmpResult = pattern( p / 3.0 );
	
	float grey = tmpResult.val; 
	
	//vec3 tmpCol = HSLToRGB( vec3( 0.7+(grey*0.4), 1.0-length(tmpResult.r), length(tmpResult.q)/1.9) );
	vec3 tmpCol = HSLToRGB( vec3( 0.5+(grey*0.4), length(tmpResult.r)/1.4, tmpResult.q.x/2.0) );
	
	gl_FragColor = vec4( tmpCol , 1.0);
}