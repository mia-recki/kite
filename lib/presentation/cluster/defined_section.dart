import '../../data/models/cluster.dart';

// NOTE: this could be configurable to allow for custom ordering
final defaultSectionsOrder = DefinedSection.values;

enum DefinedSection {
  summary('short_summary', ''),
  primaryArticle('', ''),
  highlights('talking_points', 'Highlights'),
  quote('quote', ''),
  secondaryArticle('', ''),
  perspectives('perspectives', 'Perspectives'),
  historicalBackground('historical_background', 'Historical background'),
  humanitarianImpact('humanitarian_impact', 'Humanitarian impact'),
  technicalDetails('technical_details', 'Technical details'),
  businessAngleText('business_angle_text', 'Business angle'),
  businessAnglePoints('business_angle_points', 'Business angle'),
  internationalReactions('international_reactions', 'International reactions'),
  scientificSignificance('scientific_significance', 'Scientific significance'),
  performanceStatistics('performance_statistics', 'Performance statistics'),
  leagueStanding('league_standing', 'League standing'),
  designPrinciples('design_principles', 'Design principles'),
  userExperienceImpact('user_experience_impact', 'User experience impact'),
  gameplayMechanics('gameplay_mechanics', 'Gameplay mechanics'),
  industryImpact('industry_impact', 'Industry impact'),
  travelAdvisory('travel_advisory', 'Travel advisory'),
  technicalSpecifications('technical_specifications', 'Technical specifications'),
  timeline('timeline', 'Timeline of events'),
  sources('sources', 'Sources'),
  userActionItems('user_action_items', 'Action items'),
  didYouKnow('did_you_know', 'Did you know?');

  final String key;

  // NOTE: with proper localization support, the title would be fetched by [key] from localization sources
  final String title;

  const DefinedSection(this.key, this.title);

  Section? getSection(Cluster cluster) => cluster.getSection(key);
  PointsSection? getPointsSection(Cluster cluster) => cluster.getSection(key) as PointsSection?;
}
