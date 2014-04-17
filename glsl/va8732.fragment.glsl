#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141;

//ISO 3166-1 alpha-2 names, please!
#define AM 0
#define AT 1
#define BD 2
#define BE 3
#define BG 4
#define CI 5
#define DE 6
#define EE 7
#define FR 8
#define GA 9
#define GN 10
#define HU 11
#define ID 12
#define IE 13
#define IT 14
#define JP 15
#define LT 16
#define LU 17
#define MC 18
#define ML 19
#define MU 20
#define NL 21
#define NG 22
#define PE 23
#define PL 24
#define PW 25
#define RO 26
#define RU 27 //hello
#define SL 28
#define TD 29
#define UA 30
#define YE 31
#define _MARS 32
#define MAX 33.0

//colors
#define BLACK vec3(0.2, 0.2, 0.2)
#define BLUE vec3(0.0, 0.0, 1.2)
#define GREEN vec3(0.0, 1.2, 0.0)
#define ORANGE vec3(1.2, 0.6, 0.0)
#define RED vec3(1.2, 0.0, 0.0)
#define WHITE vec3(1.2, 1.2, 1.2)
#define YELLOW vec3(1.2, 1.2, 0.0)


#define DX_MAX 105.0
#define DY_MAX 60.0

vec3 countryColor(vec2 position, int country)
{
	// dicolor H
	{
		if(position.y > 0.0)
		{
			if (country == ID) return RED;
			if (country == MC) return RED;
			if (country == PL) return WHITE;
			if (country == UA) return BLUE;
		}
		else
		{
			if (country == ID) return WHITE;
			if (country == MC) return WHITE;
			if (country == PL) return RED;
			if (country == UA) return YELLOW;
		}
	}
		
	// tricolor H
	{
		if(position.y > DY_MAX/3.0)
		{
			if (country == AM) return RED;
			if (country == AT) return RED;
			if (country == BG) return WHITE;
			if (country == DE) return BLACK;
			if (country == EE) return BLUE;
			if (country == GA) return GREEN;
			if (country == HU) return RED;
			if (country == LU) return YELLOW;
			if (country == LU) return RED;
			if (country == NL) return RED;
			if (country == RU) return WHITE;
			if (country == SL) return GREEN;
			if (country == YE) return RED;
		}
		else if(position.y > -DY_MAX/3.0)
		{
			if (country == AM) return BLUE;
			if (country == AT) return WHITE;
			if (country == BG) return GREEN;
			if (country == DE) return RED;
			if (country == EE) return BLACK;
			if (country == GA) return YELLOW;
			if (country == HU) return WHITE;
			if (country == LT) return GREEN;
			if (country == LU) return WHITE;
			if (country == NL) return WHITE;
			if (country == RU) return BLUE;
			if (country == SL) return WHITE;
			if (country == YE) return WHITE;
		}
		else
		{
			if (country == AM) return ORANGE;
			if (country == AT) return RED;
			if (country == BG) return RED;
			if (country == DE) return YELLOW;
			if (country == EE) return WHITE;
			if (country == GA) return BLUE;
			if (country == HU) return GREEN;
			if (country == LT) return RED;
			if (country == LU) return BLUE;
			if (country == NL) return BLUE;
			if (country == RU) return RED;
			if (country == SL) return BLUE;
			if (country == YE) return BLACK;
		}
	}
	
	// tricolor V
	{
		if(position.x < -DX_MAX/3.0)
		{
			if (country == BE) return BLACK;
			if (country == CI) return ORANGE;
			if (country == FR) return BLUE;
			if (country == GN) return RED;
			if (country == IE) return GREEN;
			if (country == IT) return GREEN;
			if (country == ML) return GREEN;
			if (country == NG) return GREEN;
			if (country == PE) return RED;
			if (country == RO) return BLUE;
			if (country == TD) return BLUE;
			if (country == _MARS) return RED;
		}
		else if(position.x < DX_MAX/3.0)
		{
			if (country == BE) return YELLOW;
			if (country == CI) return WHITE;
			if (country == FR) return WHITE;
			if (country == GN) return YELLOW;
			if (country == IE) return WHITE;
			if (country == IT) return WHITE;
			if (country == ML) return YELLOW;
			if (country == NG) return WHITE;
			if (country == PE) return WHITE;
			if (country == RO) return YELLOW;
			if (country == TD) return YELLOW;
			if (country == _MARS) return GREEN;
		}
		else
		{
			if (country == BE) return RED;
			if (country == CI) return GREEN;
			if (country == FR) return RED;
			if (country == GN) return GREEN;
			if (country == IE) return ORANGE;
			if (country == IT) return RED;
			if (country == ML) return RED;
			if (country == NG) return GREEN;
			if (country == PE) return RED;
			if (country == RO) return RED;
			if (country == TD) return RED;
			if (country == _MARS) return BLUE;
		}
	}
	
	// quadcolor H
	{
		if(position.y > DY_MAX/2.0)
		{
			if (country == MU) return RED;
		}
		else if(position.y > 0.0)
		{
			if (country == MU) return BLUE;
		}
		if(position.y > -DY_MAX/2.0)
		{
			if (country == MU) return YELLOW;
		}
		else
		{
			if (country == MU) return GREEN;
		}
	}
	
	// round
	{
		if(length(position.xy-vec2(0.8,0.0)) < 37.0)
		{
			if ( country == BD ) return GREEN;
			if ( country == JP ) return RED;
			if ( country == PW ) return YELLOW;
		}
		else
		{
			if ( country == BD ) return RED;
			if ( country == JP ) return WHITE;
			if ( country == PW ) return BLUE;
		}

	}
	return vec3(0.4,0.4,0.4);
}

void main(void) 
{	
	vec2 position = ( gl_FragCoord.xy - resolution.xy * 0.5 ) / length(resolution.xy) * 400.0;
	vec3 color;

	if(length(position.xy-vec2(-104.8,72.0)) < 12.0) 
	{		
		color = vec3(1.0, 0.82, 0.14)*sin(1.3+(length(position.xy-vec2(-104.0,72.0))/8.0));
		gl_FragColor = vec4(color.xyz, 1.0);
	}
	else if(position.x < -DX_MAX+5.0 && position.x >-DX_MAX-5.0 && position.y <DY_MAX+5.0)
	{

		float pos = position.y * (86.0/53.0);
		
		color = vec3(1.0, 0.8, 0.6)-0.7*sin(position.x*0.10)-0.7*sin(0.70+position.x*0.5);
		gl_FragColor = vec4(color.xyz, 1.0);
	}
	else
	{
		position.x += sin(position.y * 0.1 - time*4.0) * 2.0 + sin(position.x * 0.2 - time*6.0);
		position.y += sin(position.x * 0.1 - time*3.0) * 2.0 + 1.5*sin(position.y * 0.2 - time*2.0);
		float pos = position.y * (86.0/53.0);
		
		if(abs(position.x) < DX_MAX && abs(position.y) <DY_MAX)
			color = countryColor(position, int( mod(time,MAX) ));
		
		gl_FragColor = vec4(color * (-cos(position.x * 0.1 - time) * 0.3 + 0.7), 1.);
	}
}