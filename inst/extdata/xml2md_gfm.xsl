<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:md="http://commonmark.org/xml/1.0">


<!-- Import commonmark XSL -->

<xsl:import href="xml2md.xsl"/>
<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

<!-- params -->

<xsl:output method="text" encoding="utf-8"/>


<!-- Table -->

<xsl:template match="md:table">
    <xsl:apply-templates select="." mode="indent-block"/>
    <xsl:apply-templates select="md:*"/>
</xsl:template>

<xsl:template match="md:table_header">
    <xsl:text>| </xsl:text>
    <xsl:apply-templates select="md:*"/>
    <xsl:text>&#xa;|</xsl:text>
     <xsl:for-each select="md:table_cell">
     <xsl:choose>
     <xsl:when test="@align = 'right'">
       <xsl:call-template name="header-line">
         <xsl:with-param name="pos" select="@sourcepos"/>
         <xsl:with-param name="right" select ="':|'"/>
       </xsl:call-template>
     </xsl:when>
     <xsl:when test="@align = 'left'">
       <xsl:call-template name="header-line">
         <xsl:with-param name="pos" select="@sourcepos"/>
         <xsl:with-param name="left" select ="':'"/>
       </xsl:call-template>
     </xsl:when>
     <xsl:when test="@align = 'center'">
       <xsl:call-template name="header-line">
         <xsl:with-param name="pos" select="@sourcepos"/>
         <xsl:with-param name="left" select ="':'"/>
         <xsl:with-param name="right" select ="':|'"/>
       </xsl:call-template>
     </xsl:when>
     <xsl:otherwise>
     <xsl:text>---|</xsl:text>
     </xsl:otherwise>
     </xsl:choose>
     </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template name="header-line">
  <xsl:param name="pos"/>
  <xsl:param name="left" select="'-'"/>
  <xsl:param name="right" select="'-|'"/>

  <xsl:value-of select="$left"/>
  <xsl:choose>

    <xsl:when test="$pos">
      <xsl:variable name="start" select="number(substring-after(substring-before($pos, '-'), ':'))"/>
      <xsl:variable name="end"   select="number(substring-after(substring-after($pos, '-'), ':'))"/>
      <xsl:if test="($end - $start) &gt; 0">
        <xsl:call-template name="sequenceDashes">
          <xsl:with-param name="pStart" select="$start - $start + 1"/>
          <xsl:with-param name="pEnd" select="$end - $start - 1"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:text>--</xsl:text>
    </xsl:otherwise>

  </xsl:choose>
  <xsl:value-of select="$right"/>

</xsl:template>


<!-- Create a sequence of dashes for markdown header -->
<!-- https://stackoverflow.com/a/12720309/2752888 -->

 <xsl:template name="sequenceDashes">
  <xsl:param name="pStart"/>
  <xsl:param name="pEnd"/>
  <xsl:param name="out" select="'-'"/>

  <xsl:if test="not($pStart > $pEnd)">
   <xsl:choose>
    <xsl:when test="$pStart = $pEnd">
      <xsl:value-of select="$out"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="vMid" select=
       "floor(($pStart + $pEnd) div 2)"/>
      <xsl:call-template name="sequenceDashes">
       <xsl:with-param name="pStart" select="$pStart"/>
       <xsl:with-param name="pEnd" select="$vMid"/>
      </xsl:call-template>
      <xsl:call-template name="sequenceDashes">
       <xsl:with-param name="pStart" select="$vMid+1"/>
       <xsl:with-param name="pEnd" select="$pEnd"/>
      </xsl:call-template>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
 </xsl:template>

<xsl:template match="md:table_cell">
    <xsl:apply-templates select="md:*"/>
    <xsl:text>| </xsl:text>
</xsl:template>

<xsl:template match="md:table_row">
    <xsl:text>| </xsl:text>
    <xsl:apply-templates select="md:*"/>
    <xsl:text>&#xa;</xsl:text>
</xsl:template>


<!-- Striked-through -->

<xsl:template match="md:strikethrough">
    <xsl:text>~~</xsl:text>
    <xsl:apply-templates select="md:*"/>
    <xsl:text>~~</xsl:text>
</xsl:template>

</xsl:stylesheet>
