import 'demo_data/donations_demo.dart';

/// Simple in‑memory "provider" for donation data.
///
/// This is *not* using any external state‑management package on purpose – the
/// goal is to keep things easy to read as you are learning. The Home page will
/// ask this provider for:
///   - the list of donations
///   - helper methods to toggle the "liked" state of a donation
///
/// Because everything is in memory, a hot‑restart of the app will reset likes.
class DonationsProvider {
  DonationsProvider._internal();

  /// Singleton instance so the whole app can share the same in‑memory state.
  static final DonationsProvider instance = DonationsProvider._internal();

  /// Internal mutable copy of the demo donations.
  ///
  /// We copy `demoDonations` so we can sort / filter later if we want to,
  /// without touching the original constant list.
  final List<Donation> _donations = List<Donation>.from(demoDonations);

  /// Tracks which donation ids are currently "liked" by the user.
  ///
  /// Instead of storing `isLiked` on the `Donation` model itself (which is
  /// meant to represent data coming from a backend), we keep this as separate
  /// local UI state.
  final Set<String> _likedDonationIds = <String>{};

  /// Public *read‑only* view of the donations list.
  ///
  /// Returning `List.unmodifiable` here makes it impossible for caller code to
  /// accidentally change items without going through our helper methods.
  List<Donation> get donations => List<Donation>.unmodifiable(_donations);

  /// Returns `true` if the given donation id is currently liked.
  bool isLiked(String donationId) => _likedDonationIds.contains(donationId);

  /// Toggle the "liked" state of a donation by id and return the new state.
  bool toggleLike(String donationId) {
    if (_likedDonationIds.contains(donationId)) {
      _likedDonationIds.remove(donationId);
      return false;
    } else {
      _likedDonationIds.add(donationId);
      return true;
    }
  }
}
